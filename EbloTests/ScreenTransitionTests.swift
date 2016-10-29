//
//  ScreenTransitionManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import XCTest
@testable import Eblo

class ScreenTransitionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainViewControllerTransition() {
      let mainViewController = MainViewController()
      let mainCompanyBlogs = ScreenTransitionManager.transitionScreenWith(viewController: mainViewController, entryPoint: mainViewController.companyEntry)
      XCTAssert(mainCompanyBlogs == "Eblo/EditRecordViewController/action=navigate")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
