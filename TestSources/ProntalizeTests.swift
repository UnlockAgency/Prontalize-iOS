//
//  ProntalizeTests.swift
//  
//
//  Created by Bas van Kuijck on 14/12/2022.
//

import Foundation
import XCTest
import ViewInspector
@testable import Prontalize

class ProntalizeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        Prontalize.instance.isEnabled = true
        
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
        XCTAssertEqual(NSLocalizedString("welcome", bundle: .prontalize, comment: ""), "Welcome")
        
        guard let url = Bundle.module.url(forResource: "response-mock", withExtension: "json") else {
            fatalError("Cannot find 'response-mock'")
        }
        
        let data = try Data(contentsOf: url)
        
        try Prontalize.instance.decodeAndWrite(data: data)
        
        let string = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
        XCTAssertEqual(string, "Welcome again")
        
        let pluralStringOther = String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 12)
        XCTAssertEqual(pluralStringOther, "12 apples")
        
        let pluralStringOne = String(format: NSLocalizedString("apples", bundle: .prontalize, comment: ""), 1)
        XCTAssertEqual(pluralStringOne, "1 apple")
    }
    
    func testEnabledDisabled() throws {
        guard let url = Bundle.module.url(forResource: "response-mock", withExtension: "json") else {
            fatalError("Cannot find 'response-mock'")
        }
        
        let fallbackString = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
        XCTAssertEqual(fallbackString, "Welcome")
        
        Prontalize.instance.isEnabled = false
        
        let data = try Data(contentsOf: url)
        
        // Double sync, the second one will have no effect
        try Prontalize.instance.decodeAndWrite(data: data)
        try Prontalize.instance.decodeAndWrite(data: data)
        
        let disabledString = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
        XCTAssertEqual(disabledString, "Welcome")
        
        Prontalize.instance.isEnabled = true
        
        let enabledString = NSLocalizedString("welcome", bundle: .prontalize, comment: "")
        XCTAssertEqual(enabledString, "Welcome again")
    }
    
    @MainActor
    func testProntalizedTextView() async throws {
        guard let url = Bundle.module.url(forResource: "response-mock", withExtension: "json") else {
            fatalError("Cannot find 'response-mock'")
        }
        let view = ProntalizedText("welcome")
        
        let sut = try view.inspect()
        let string1 = try sut.text().string()
        XCTAssertEqual(string1, "Welcome")
        
        let data = try Data(contentsOf: url)
        try Prontalize.instance.decodeAndWrite(data: data)
        
        let string2 = try sut.text().string()
        XCTAssertEqual(string2, "Welcome again")

        let pluralView = ProntalizedText("apples", pluralCount: 3)
        
        let string3 = try pluralView.inspect().text().string()
        XCTAssertEqual(string3, "3 apples")
    }
}

extension ProntalizedText: Inspectable { }
