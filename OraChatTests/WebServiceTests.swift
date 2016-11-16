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
    
    func testThatRequestedResourceIsCorrect() {

		/*
		Given
		*/
		let testMethod: HttpMethod<Any> = .put(["testBodyKey" : "testBodyValue"] as JSONDictionary)
		let testPath = "testpath"
		
		let resource = WebResource<Int>(path: testPath, method: testMethod) {
			_ in
			return Optional<Int>.none
		}
		
		/*
		When
		*/
		let dataTask = webService.load(resource) {(_, _) in}

		/*
		Then
		*/
		let request = dataTask.originalRequest
		let url = request?.url
		
		XCTAssertNotNil(request, "resource hasn't been requested")
		XCTAssertNotNil(url, "resource url that has been requested is invalid")
		XCTAssertEqual(request?.httpMethod, testMethod.text, "resource has been requested using a wrong http method")
		XCTAssertTrue(url!.path.contains(testPath), "resource path that has been requested is wrong")
    }
}
