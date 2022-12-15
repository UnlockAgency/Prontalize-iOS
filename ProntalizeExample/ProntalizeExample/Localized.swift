//
//  Localized.swift
//  ProntalizeExample
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation
import Prontalize
import SwiftUI

struct ProntalizeString {
    let key: String
    let isPlural: Bool
    let count: Int
}

enum Localized {
    static func `get`(_ key: String) -> ProntalizeString {
        return ProntalizeString(key: key, isPlural: false, count: 0)
    }
    
    static func `plural`(_ key: String, _ count: Int) -> ProntalizeString {
        return ProntalizeString(key: key, isPlural: true, count: count)
    }
}

func Text(_ prontalizeString: ProntalizeString) -> some View {
    ProntalizedText(prontalizeString.key, isPlural: prontalizeString.isPlural, count: prontalizeString.count)
} 
