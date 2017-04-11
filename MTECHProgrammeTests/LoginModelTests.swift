//
//  LoginModelTests.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import XCTest
@testable import MTECHProgramme

class LoginModelTests: XCTestCase {
    
    var loginModel : LoginModel = LoginModel()
    
    override func setUp() {
        super.setUp()
        loginModel = LoginModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsUserOrPasswordEmpty() {
        XCTAssert(self.loginModel.isUserOrPasswordEmpty(userID: "", password: ""))
        XCTAssert(self.loginModel.isUserOrPasswordEmpty(userID: nil, password: "password"))
        XCTAssert(self.loginModel.isUserOrPasswordEmpty(userID: "userName", password: nil))
        XCTAssert(!self.loginModel.isUserOrPasswordEmpty(userID: "userName", password: "password"))
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
