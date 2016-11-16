//
//  AuthenticationInfoTests.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import XCTest
@testable import OraChat


class AuthenticationInfoTests: XCTestCase {
	
	var authenticationInfo: AuthenticationInfo!
    
    func testAuthenticationInfoSerialization() {

		/*
		Given
		*/
		let test = type(of: self)
		authenticationInfo = AuthenticationInfo(email: test.email, password: test.password)
		
		/*
		When
		*/
		let json = authenticationInfo.json
		
		/*
		Then
		*/
		let stringJson = json as? [String : String]
		
		XCTAssertNotNil(stringJson, "invalid json data type")
		XCTAssertEqual(stringJson!, ["email": test.email, "password": test.password], "invalid json data")
    }
    
	static private let email = "example@host.net"
	static private let password = "P@ssw0rd"
}
