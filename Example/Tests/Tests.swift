import UIKit
import XCTest
@testable import JWValidator

class Tests: XCTestCase {
    
    let validationInstance = JWValidation.shared;
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
        XCTAssertTrue(JWValidation.shared.validateText("aqq", type: FieldType.Name), "")
        JWValidation.shared.setNameRequirement(6)
        XCTAssertFalse(JWValidation.shared.validateText("aqq", type: FieldType.Name), "")
    }
    
    func testZip() {
        XCTAssertTrue(JWValidation.shared.validateText("56565", type: FieldType.Zipcode), "")
        JWValidation.shared.setLongZipCode(true)
        XCTAssertFalse(JWValidation.shared.validateText("56565", type: FieldType.Zipcode), "")
        XCTAssertTrue(JWValidation.shared.validateText("565656565", type: FieldType.Zipcode), "")
        XCTAssertTrue(JWValidation.shared.validateText("56650-", type: FieldType.Zipcode), "")
        XCTAssertTrue(JWValidation.shared.validateText("56565-6565", type: FieldType.Zipcode), "")
        XCTAssertFalse(JWValidation.shared.validateText("56-56", type: FieldType.Zipcode), "")
    }
    
    func testSetPasswordRegex() {
        JWValidation.shared.setPasswordRegex("^[a-zA-Z]\\w{3,14}$")
        XCTAssertTrue(JWValidation.shared.validateText("abcd", type: FieldType.Password), "")
        XCTAssertFalse(JWValidation.shared.validateText("a$%bcd", type: FieldType.Password), "")
        JWValidation.shared.setPasswordRegex("(?=^.{8,30}$)(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&amp;*()_+}{&quot;&quot;:;'?/&gt;.&lt;,]).*$")
        XCTAssertFalse(JWValidation.shared.validateText("abcd", type: FieldType.Password), "")
        XCTAssertFalse(JWValidation.shared.validateText("a$%bcd", type: FieldType.Password), "")
        XCTAssertTrue(JWValidation.shared.validateText("A$gfg56@4^", type: FieldType.Password), "")
    }
    
    func testPhoneNumber() {
        XCTAssertFalse(JWValidation.shared.validateText("123", type: FieldType.PhoneNumber), "")
        XCTAssertTrue(JWValidation.shared.validateText("123-456-7890", type: FieldType.PhoneNumber), "")
        XCTAssertFalse(JWValidation.shared.validateText("87abcd6345", type: FieldType.PhoneNumber), "")
        XCTAssertTrue(JWValidation.shared.validateText("1+(567)-343-4565", type: FieldType.PhoneNumber), "")
    }
}
