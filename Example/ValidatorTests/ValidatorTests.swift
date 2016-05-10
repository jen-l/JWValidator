//
//  ValidatorTests.swift
//  ValidatorTests
//
//  Created by Jenelle Walker on 1/9/15.
//  Copyright (c) 2015 Jenelle Walker. All rights reserved.
//

import XCTest

class ValidatorTests: XCTestCase {
    let validationInstance = Validation.shared;
    let passwordRegex: String =  "(?=^.{6,255}$)((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEmailValidation() {
        XCTAssertTrue(validationInstance.isValidEmail("arshemet@gmail.com", strict: true), "email validation returned false")
        XCTAssertFalse(validationInstance.isValidEmail("arshemet@gmail.c", strict: true), "email validation returned true for strict regex")
        XCTAssertFalse(validationInstance.isValidEmail("", strict: true), "empty email returned true")
    }
    
    func testPasswordValidation() {
        XCTAssertFalse(validationInstance.isValidPassword("", regex: self.passwordRegex), "empty password was true")
        XCTAssertTrue(validationInstance.isValidPassword("q3@4Jf$gs", regex: self.passwordRegex), "valid password was false")
    }
    
    func testSetNameReqValidation() {
        XCTAssertTrue(Validation.shared.validateText("aqq", type: FieldType.Name), "")
        Validation.shared.setNameRequirement(6)
        XCTAssertFalse(Validation.shared.validateText("aqq", type: FieldType.Name), "")
    }
    
    func testZip() {
        XCTAssertTrue(Validation.shared.validateText("56565", type: FieldType.Zipcode), "")
        Validation.shared.setLongZipCode(true)
        XCTAssertFalse(Validation.shared.validateText("56565", type: FieldType.Zipcode), "")
        XCTAssertTrue(Validation.shared.validateText("565656565", type: FieldType.Zipcode), "")
        XCTAssertFalse(Validation.shared.validateText("56650-", type: FieldType.Zipcode), "")
        XCTAssertTrue(Validation.shared.validateText("56565-6565", type: FieldType.Zipcode), "")
        XCTAssertFalse(Validation.shared.validateText("56-56", type: FieldType.Zipcode), "")
    }
    
    func testSetPasswordRegex() {
        Validation.shared.setPasswordRegex("^[a-zA-Z]\\w{3,14}$")
        XCTAssertTrue(Validation.shared.validateText("abcd", type: FieldType.Password), "")
        XCTAssertFalse(Validation.shared.validateText("a$%bcd", type: FieldType.Password), "")
        Validation.shared.setPasswordRegex("(?=^.{8,30}$)(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&amp;*()_+}{&quot;&quot;:;'?/&gt;.&lt;,]).*$")
        XCTAssertFalse(Validation.shared.validateText("abcd", type: FieldType.Password), "")
        XCTAssertFalse(Validation.shared.validateText("a$%bcd", type: FieldType.Password), "")
        XCTAssertTrue(Validation.shared.validateText("A$gfg56@4^", type: FieldType.Password), "")
    }
    
    func testPhoneNumber() {
        XCTAssertFalse(Validation.shared.validateText("123", type: FieldType.PhoneNumber), "")
        XCTAssertTrue(Validation.shared.validateText("123-456-7890", type: FieldType.PhoneNumber), "")
        XCTAssertFalse(Validation.shared.validateText("87abcd6345", type: FieldType.PhoneNumber), "")
        XCTAssertTrue(Validation.shared.validateText("1+(567)-343-4565", type: FieldType.PhoneNumber), "")
    }
}
