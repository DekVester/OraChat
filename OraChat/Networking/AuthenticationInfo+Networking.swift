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
		return dynamicType.authorizationWithData(json, urlPath: dynamicType.urlPath)
	}
	
	static func authorizationWithData(_ json: JSONDictionary, urlPath: String) -> WebResource<AuthorizationToken> {
		
		let authorizationResource = WebResource<AuthorizationToken>(path: urlPath, method: .post(json)) {
			
			json in
			guard let jsonDict = json as? JSONDictionary else {return nil}
			guard let jsonData = jsonDict["data"] as? JSONDictionary else {return nil}
			return jsonData["token"] as? AuthorizationToken
		}
		
		return authorizationResource
	}
	
	static let urlPath = "users/login"
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
