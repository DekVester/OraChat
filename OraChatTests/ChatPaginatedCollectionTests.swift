//
//  ChatPaginatedCollectionTests.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class ChatPaginatedCollectionTests: XCTestCase {

	var chatsCollection: PaginatedCollection<Chat>!
	
	override func setUp() {
		super.setUp()
		
		chatsCollection = PaginatedCollection<Chat>(parentDomain: nil, id: nil, pagination: Pagination(limit: 1))
	}
	
	func testThatNewChatCreationWebResourceIsValid() {
		
		/*
		Given
		*/
		let test = type(of: self)
		
		/*
		When
		*/
		let webResource = chatsCollection.new(item: test.chat)

		/*
		Then
		*/
		let correctMethod = WebResource<Chat>(path: "", method: .post(test.chat.json)) {_ in return nil}.method
		
		let methodsEqual = test.equal(webResource.method, correctMethod)
		XCTAssertTrue(methodsEqual, "invalid resource")
	}
	
	static private func equal(_ lhs: HttpMethod<Data>, _ rhs: HttpMethod<Data>) -> Bool {
		
		switch (lhs, rhs) {
		case (let .post(lhsBody), let .post(rhsBody)):
			return lhsBody == rhsBody
			
		case (let .put(lhsBody), let .put(rhsBody)):
			return lhsBody == rhsBody
			
		case (.get, .get):
			return true
			
		default:
			return false
		}
	}
	
	static private let chat = Chat(name: "A test chat")
}
