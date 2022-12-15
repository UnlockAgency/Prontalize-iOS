//
//  Bundle+extension.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation

public extension Bundle {
    static var prontalize: Bundle {
        return Prontalize.instance.bundle
    }
}
