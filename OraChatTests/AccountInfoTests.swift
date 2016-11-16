//
//  AccountInfoTests.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class AccountInfoTests: XCTestCase {
    
	var accountInfo: AccountInfo!
	
	func testAccountInfoSerialization() {
		
		/*
		Given
		*/
		let test = type(of: self)
		accountInfo = AccountInfo(authenticationInfo: test.authenticationInfo, name: test.name, passwordConfirmation: test.authenticationInfo.password)
		
		/*
		When
		*/
		let json = accountInfo.json
		
		/*
		Then
		*/
		let stringJson = json as? [String : String]
		let correctJson = ["name": test.name, "email": test.authenticationInfo.email, "password": test.authenticationInfo.password, "confirm": test.authenticationInfo.password]
		
		XCTAssertNotNil(stringJson, "invalid json data type")
		XCTAssertEqual(stringJson!, correctJson, "invalid json data")
	}
	
	static private let authenticationInfo = AuthenticationInfo(email: "example@host.net", password: "P@ssw0rd")
	static private let name = "John Doe"
}
