//
//  AuthenticationInfo+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


typealias AuthorizationToken = String


extension AuthenticationInfo {
	
	var login: WebResource<AuthorizationToken> {

		let dynamicType = type(of: self)
		return dynamicType.authorizationWithData(json, url: dynamicType.url)
	}
	
	static func authorizationWithData(_ json: JSONDictionary, url: URL) -> WebResource<AuthorizationToken> {
		
		let authorizationResource = WebResource<AuthorizationToken>(url: url, method: .post(json)) {
			
			json in
			guard let jsonDict = json as? JSONDictionary else {return nil}
			guard let jsonData = jsonDict["data"] as? JSONDictionary else {return nil}
			return jsonData["token"] as? AuthorizationToken
		}
		
		return authorizationResource
	}
	
	static let url = URL(string:"http://private-d9e5b-oracodechallenge.apiary-mock.com/users/login")!
}


extension AuthenticationInfo: JSONSerializable {
	
	init?(json: JSONDictionary) {
		
		guard let jsonData = json["data"] as? JSONDictionary else {return nil}
		guard let anEmail = jsonData["email"] as? String else {return nil}
		
		email = anEmail
		password = ""
	}
	
	var json: JSONDictionary {
		
		return ["email": email, "password": password]
	}
}
