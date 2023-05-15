//
//  FirebaseDemoTests.swift
//  FirebaseDemoTests
//
//  Created by sahil bhatia on 15/05/23.
//  Copyright © 2023 sahil bhatia. All rights reserved.
//

import XCTest
@testable import FirebaseDemo

class FirebaseDemoTests: XCTestCase {

    let authManager:FireBaseManagerHelper = FirebaseAuthManager()

    func testExample() {
        
        let timeOut: TimeInterval = 2
        let expectation = self.expectation(description: "Awaiting for Response")
        authManager.createUserWith(email: "abc3@mail.com", password: "12345678") { (success, error , _ ) in
            if success {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: timeOut, handler: nil)
    }

    func testLogIn() {
        let timeOut: TimeInterval = 2
        let expectation = self.expectation(description: "Awaiting for Response")
        authManager.signInWith(email: "abc2@mail.com", password: "1234567") { (success, error , _ ) in
            if success {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func testGetDataFromFirestore() {
        let timeOut: TimeInterval = 2
        let expectation = self.expectation(description: "Awaiting for Response")
        DatabaseManager.shared.fetchEmployessFromCollection(documentID: "1n1HrtuNR3eEU1Jx2flTzDVsj1Y2") { (data) in
            if !data.isEmpty {
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: timeOut, handler: nil)
    }

}
