//
//  EbloString.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import XCTest
@testable import Eblo

class EbloStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuery() {
      let queryString = "company=Yelp&companyURL=https://engineeringblog.yelp.com"
      let result = queryString.queryKeysAndValues()
      if let company = result?["company"], company != "Yelp" {
        XCTFail()
      }
      if let companyURL = result?["companyURL"], companyURL != "https://engineeringblog.yelp.com" {
        XCTFail()
      }
      XCTAssert(true)
    }
  
  func testConcatenate() {
    let base = "http://abc/blog/"
    let blogURL = "/blog/article"
    XCTAssert("http://abc/blog/article" == String.concatenateTwoStringWithoutRepeatedCharactersAtTheJointPoint(firstString: base, secondeString: blogURL))
    let randomPre = "random/"
    let randomPost = "/lol"
    XCTAssert("random/lol" == String.concatenateTwoStringWithoutRepeatedCharactersAtTheJointPoint(firstString: randomPre, secondeString: randomPost))
  }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
