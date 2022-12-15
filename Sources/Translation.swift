//
//  Translation.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation

struct TranslationKey: Codable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case id
        case identifier
        case platforms
        case keyType = "key_type"
        case isPlural = "pluralization_enabled"
        case translations
    }
    let id: String
    let identifier: String
    let platforms: [Platform]
    let keyType: KeyType
    let isPlural: Bool
    let translations: [Translation]
}

extension TranslationKey {
    enum Platform: String, Codable {
        case ios
        case android
        case web
    }
    
    enum KeyType: String, Codable {
        case app
        case store
        case metadata
    }
    
    struct Translation: Codable {
        let locale: String
        let value: String
        let plural: PluralType?
    }
}

extension TranslationKey.Translation {
    enum PluralType: String, Codable {
        case few
        case one
        case two
        case zero
        case many
        case other
    }
}

struct TranslationContainer: Codable {
    let data: [TranslationKey]
}
