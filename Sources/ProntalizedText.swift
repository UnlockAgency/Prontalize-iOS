//
//  ProntalizedText.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation
import SwiftUI

public struct ProntalizedText: View {
    @ObservedObject private var prontalize = Prontalize.instance
    private let key: String
    private let pluralCount: Int?
    
    public init(_ key: String, pluralCount: Int? = nil) {
        self.key = key
        self.pluralCount = pluralCount
    }
    
    private var string: String {
        let localized = NSLocalizedString(key, bundle: prontalize.bundle, comment: "")
        
        guard let pluralCount else {
            return localized
        }

        return String(format: localized, pluralCount)
    }
    
    public var body: some View {
        Text("\(string)", bundle: nil)
    }
}

public func Text(_ string: String, pluralCount: Int? = nil) -> ProntalizedText {
    return ProntalizedText(string, pluralCount: pluralCount)
}
