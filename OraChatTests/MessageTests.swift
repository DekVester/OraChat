//
//  MessageTests.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class MessageTests: XCTestCase {

	var message: Message!
	
	func testMessageSerialization() {
		
		/*
		Given
		*/
		let test = type(of: self)
		message = Message(text: test.text)
		
		/*
		When
		*/
		let json = message.json
		
		/*
		Then
		*/
		let stringJson = json as? [String : String]
		
		XCTAssertNotNil(stringJson, "invalid json data type")
		XCTAssertEqual(stringJson!, ["message": test.text], "invalid json data")
	}
	
	static private let text = "Hey there!"
}
