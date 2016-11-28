//
//  Challenge3Tests.swift
//  Challenge3Tests
//
//  Created by Tiago Queiroz on 10/11/16.
//  Copyright © 2016 Tiago Queiroz. All rights reserved.
//

import XCTest
import HealthKit
@testable import Challenge3

class Challenge3Tests: XCTestCase {
    
    let healthManger = HealthKitManager()
    let userDataManager = UserDataManager()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthorization(){
        
        let exp = expectation(description: "Waiting answer")
        let completion: ((Bool, Error?) -> Void)! = {
            (success, error) -> Void in
            
            if !success {
                
                print("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error). If you're using a simulator, try it on a device.")
                
                return
            }
            
            print("User allowed HealthKit")
            exp.fulfill()
        }
        
        healthManger.authorizeHealthKit(completion: completion)
        
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }

    }
    
    func testDataNotNil(){
        let age = healthManger.receiveUserData().age
        let bloodType = healthManger.receiveUserData().bloodtype
        let biologicalSex = healthManger.receiveUserData().biologicalsex
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
    
    

    func testSaveNickName(){
        let nick = "name"
        self.userDataManager.nickName = nick
        self.userDataManager.saveNickName(nickName: "test")
        XCTAssertNotEqual(nick, self.userDataManager.nickName, "O nick nao esta sendo salvo corretamento")
    }
    

    func testUserExist(){
    
        var text = "none"
        userDataManager.saveNickName(nickName: "test")
        text = userDataManager.nickName
        
        XCTAssert((text == "test")||userDataManager.UserExist(), "nao consiguiu verificar exitencia do usuario")
        
    }
    
}
