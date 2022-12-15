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
    private let isPlural: Bool
    private let count: Int
    
    public init(_ key: String, isPlural: Bool = false, count: Int = 0) {
        self.key = key
        self.isPlural = isPlural
        self.count = count
    }
    
    private var string: String {
        let localized = NSLocalizedString(key, bundle: .prontalize, comment: "")
        if !isPlural {
            return localized
        }
        
        return String(format: localized, count)
    }
    
    public var body: Text {
        Text(string)
    }
}
