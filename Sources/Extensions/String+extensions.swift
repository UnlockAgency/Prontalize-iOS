//
//  File.swift
//  
//
//  Created by Bas van Kuijck on 15/12/2022.
//

import Foundation

extension String {
    func escape() -> String {
        return self
            .replacingOccurrences(of: "\\\n", with: "\\n")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\\\r", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "%s", with: "%@")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
}
