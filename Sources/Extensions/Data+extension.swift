//
//  Data+extension.swift
//  
//
//  Created by Bas van Kuijck on 15/12/2022.
//

import Foundation
import CryptoKit

extension Data {
    var md5Hash: String {
        let digest = Insecure.MD5.hash(data: self)        
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
