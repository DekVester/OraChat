//
//  ChatTests.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class ChatTests: XCTestCase {
	
	var chat: Chat!
	
	func testChatSerialization() {
		
		/*
		Given
		*/
		let test = type(of: self)
		chat = Chat(name: test.name)
		
		/*
		When
		*/
		let json = chat.json
		
		/*
		Then
		*/
		let stringJson = json as? [String : String]
		
		XCTAssertNotNil(stringJson, "invalid json data type")
		XCTAssertEqual(stringJson!, ["name": test.name], "invalid json data")
	}
	
	static private let name = "John Doe"
}
