//
//  ProntalizeTests.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation
import XCTest
@testable import Prontalize

class ProntalizeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Prontalize.instance.setup(
            apiToken: "apiToken",
            projectID: "projectID",
            fallbackBundle: .module
        )
    }
    
    override func tearDown() {
        super.tearDown()
        Prontalize.instance.clearCache()
    }
    
    func testFetch() throws {
        print("Current bundle:", Prontalize.instance.bundle)
        XCTAssertEqual(NSLocalizedString("welcome", bundle: .prontalize, comment: ""), "Welcome")
        
        guard let url = Bundle.module.url(forResource: "response-mock", withExtension: "json") else {
            fatalError("Cannot find 'response-mock'")
        }
        
        let data = try Data(contentsOf: url)
        
        try Prontalize.instance.decodeAndWrite(data: data)
        
        print("Current bundle:", Prontalize.instance.bundle)
        
        let string = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
        XCTAssertEqual(string, "Welcome again")
        
        let pluralStringOther = String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 12)
        XCTAssertEqual(pluralStringOther, "12 apples")
        
        let pluralStringOne = String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 1)
        XCTAssertEqual(pluralStringOne, "1 apple")
    }
}
