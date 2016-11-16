//
//  WebServiceTests.swift
//  OraChatTests
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class WebServiceTests: XCTestCase {
	
	var webService: Webservice!
    
    override func setUp() {
        super.setUp()
        webService = Webservice()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatRequestedResourceIsCorrect() {

		let testPath = "testpath"

		let testBody: JSONDictionary = ["testBodyKey" : "testBodyValue"]
		let testMethod: HttpMethod<Any> = .put(testBody)
		
		let resource = WebResource<Int>(path: testPath, method: testMethod) {
			_ in
			return Optional<Int>.none
		}
		
		let dataTask = webService.load(resource) {(_, _) in}

		let request = dataTask.originalRequest
		let url = request?.url
		XCTAssertNotNil(request, "resource hasn't been requested")
		XCTAssertNotNil(url, "resource url that has been requested is invalid")

		XCTAssertEqual(request?.httpMethod, testMethod.text, "resource has been requested using a wrong http method")
		XCTAssertTrue(url!.path.contains(testPath), "resource path that has been requested is wrong")
		
//		XCTestExpectation
    }
}
