//
//  Prontalize.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation

public class Prontalize: ObservableObject {
    public static let instance = Prontalize()
    
    private static let userDefaultUUIDKey = "prontalize-uuid"
    private static let md5CacheKey = "prontalize-cache-md5"
    
    public var debugModus: Bool = false
    
    private var apiToken: String = ""
    private var projectID: String = ""
    
    /// A Published variable to let the system now it's refreshing / loading the new bundle
    @Published private(set) public var isFetching = false
    
    /// Enable / disable the prontalize bundle
    public var isEnabled = true {
        didSet {
            setBundle()
        }
    }
    
    /// The Bundle that points to the Prontalize resources, if no bundle is available. Use `fallbackBundle`
    private(set) public var bundle: Bundle = Bundle.main
    
    private var uuid: String = ""
    private var cachedMD5Hash: String? {
        didSet {
            UserDefaults.standard.set(cachedMD5Hash, forKey: Self.md5CacheKey)
        }
    }
    
    private var bundleURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("Prontalize_\(uuid).bundle")
    }
    
    private var fallbackBundle = Bundle.main
    
    private init() {
        if let storedUUID = UserDefaults.standard.string(forKey: Self.userDefaultUUIDKey) {
            uuid = storedUUID
        } else {
            setNewUUID()
        }
        
        cachedMD5Hash = UserDefaults.standard.string(forKey: Self.md5CacheKey)
    }
    
    /// Setup the Prontalize sdk instance
    ///
    /// - Parameters:
    ///   - apiToken: The API_TOKEN provided from prontalize.nl
    ///   - projectID: The PROJECT_ID provided from prontalize.nl (you can find this in the url of your project)
    ///   - fallbackBundle: If the prontalize bundle hasn't been loaded yet, fallback to this bundle to obtain resources from there (defaults to .main)
    public func setup(apiToken: String, projectID: String, fallbackBundle: Bundle = Bundle.main) {
        self.bundle = fallbackBundle
        self.fallbackBundle = fallbackBundle
        self.apiToken = apiToken
        self.projectID = projectID
        setBundle()
        refresh()
    }
    
    /// Refresh / (re)load the prontalize bundle
    public func refresh() {
        if isFetching {
            log("Warning - Already fetching, halting")
            return
        }
        isFetching = true
        Task {
            do {
                try await fetch()
            } catch {
                log("Error - Retrieving translations: \(error)")
            }
            Task { @MainActor in
                isFetching = false
            }
        }
    }
    
    private func setNewUUID() {
        // We use uuid's, so when an updated bundle is downloaded the new loaded bundle can be used and avoid caching
        uuid = UUID().uuidString
        UserDefaults.standard.set(uuid, forKey: Self.userDefaultUUIDKey)
    }
    
    private func precheck() {
        if apiToken.isEmpty || projectID.isEmpty {
            fatalError("apiToken and/or projectID is not set. Call `.setup(apiToken:projectID:)` first")
        }
    }
    
    private func setBundle() {
        var isDirectory: ObjCBool = false
        
        if isEnabled,
           !uuid.isEmpty,
           let bundle = Bundle(url: bundleURL),
           FileManager.default.fileExists(atPath: bundleURL.path, isDirectory: &isDirectory),
           isDirectory.boolValue {
            self.bundle = bundle
            log("Changed bundle to: \(bundleURL)")
        } else {
            log("Warning - Cannot find bundle at url \(bundleURL) or prontalize is disabled, falling back to \(fallbackBundle)")
            bundle = fallbackBundle
        }
    }
    
    private func log(_ line: String) {
        if debugModus {
            print("\(Date()) - [Prontalize] \(line)")
        }
    }
    
    private func fetch() async throws {
        precheck()
        let urlString = "https://prontalize.nl/api/projects/\(projectID)/translation_keys"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        log("Retrieving translations ...")
        let data = try await URLSession.shared.data(for: urlRequest).0
        log("Success - Succesfully received translations from prontalize")
        try decodeAndWrite(data: data)
    }
    
    func decodeAndWrite(data: Data) throws {
        /// Using an md5 hash of the response data
        /// That hash is used to check if any changes have been made in prontalize
        /// If the hash is the same as the previous one, do nothing. No need to parse the response and create a new bundle
        let responseMD5Hash = data.md5Hash
        if cachedMD5Hash == responseMD5Hash {
            log("Not creating new bundle, result is unchanged")
            return
        }
        cachedMD5Hash = responseMD5Hash
        
        log("Decoding response...")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let container = try decoder.decode(TranslationContainer.self, from: data)
        
        // Only app and iOS keys should be parsed
        let translationKeys = container.data
            .filter { $0.keyType == .app }
            .filter { $0.platforms.contains(.ios) }
        
        var localizableStrings: [URL: [String]] = [:]
        //                          [file: [identifier: [(pluralForm, value)]]]
        var localizableStringsDict: [URL: [String: [(String, String)]]] = [:]
        var lprojURLs: [URL] = []
        
        // First write everything in a temporary folder
        // After everything is parsed / written, then set the 'new' bundle
        let tempBundleURL = bundleURL.appendingPathExtension("tmp")
        for translationKey in translationKeys {
            for translation in translationKey.translations {
                let langName = translation.locale.components(separatedBy: "_").first ?? translation.locale
                
                let lprojURL = tempBundleURL.appendingPathComponent("\(langName).lproj")
                let locStringsURL = lprojURL.appendingPathComponent("Localizable.strings")
                let stringsDictURL = lprojURL.appendingPathComponent("Localizable.stringsdict")
                
                if !lprojURLs.contains(lprojURL), !FileManager.default.fileExists(atPath: lprojURL.path) {
                    try FileManager.default.createDirectory(at: lprojURL, withIntermediateDirectories: true)
                    lprojURLs.append(lprojURL)
                }
                
                let value = translation.value.escape()
                
                if translationKey.isPlural, let pluralRawValue = translation.plural?.rawValue {
                    var dictionary = localizableStringsDict[stringsDictURL] ?? [:]
                    var array = dictionary[translationKey.identifier] ?? []
                    array.append((pluralRawValue, value))
                    dictionary[translationKey.identifier] = array
                    localizableStringsDict[stringsDictURL] = dictionary
                    
                } else if !translationKey.isPlural {
                    var lines = localizableStrings[locStringsURL] ?? []
                    lines.append("\"\(translationKey.identifier)\" = \"\(value)\";")
                    localizableStrings[locStringsURL] = lines
                }
            }
        }
        
        // Localizable.strings
        for file in localizableStrings.keys {
            if let data = localizableStrings[file]?.joined(separator: "\n").data(using: .utf8) {
                log("Writing data to \(file)")
                try data.write(to: file)
            }
        }
        
        // Localizable.stringsdict
        for file in localizableStringsDict.keys {
            guard let dictionary = localizableStringsDict[file] else {
                continue
            }
            
            let writeDictionary = dictionary.keys.reduce([String: Any]()) { result, identifier in
                var result = result
                if let value = dictionary[identifier] {
                    result[identifier] = [
                        "NSStringLocalizedFormatKey": "%#@VARIABLE@",
                        "VARIABLE": value.reduce([
                            "NSStringFormatSpecTypeKey": "NSStringPluralRuleType",
                            "NSStringFormatValueTypeKey": "lld"
                        ]) { valueResult, pluralValue in
                            var valueResult = valueResult
                            valueResult[pluralValue.0] = pluralValue.1
                            return valueResult
                        }
                    ]
                }
                return result
            }
            
            let data = try PropertyListSerialization.data(
                fromPropertyList: writeDictionary,
                format: .xml,
                options: 0
            )
            log("Writing data to \(file)")
            try data.write(to: file)
            
        }
        
        log("Remove old bundle \(bundleURL)")
        try? FileManager.default.removeItem(at: bundleURL)
        setNewUUID()
        try FileManager.default.moveItem(at: tempBundleURL, to: bundleURL)
        setBundle()
        
        Task { @MainActor in
            objectWillChange.send()
        }
    }
    
    // Removes the Prontalize bundle and would result in falling back to the `fallBackBundle`
    public func clearCache() {
        cachedMD5Hash = nil
        log("Clearing cache")
        try? FileManager.default.removeItem(at: bundleURL)
        bundle = fallbackBundle
    }
}
