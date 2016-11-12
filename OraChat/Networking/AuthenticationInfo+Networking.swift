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

		let loginResource = WebResource<AuthorizationToken>(url: type(of: self).url, method: .post(json)) {
			
			json in
			guard let jsonDict = json as? JSONDictionary else {return nil}
			guard let jsonData = jsonDict["data"] as? JSONDictionary else {return nil}
			return jsonData["token"] as? AuthorizationToken
		}
		
		return loginResource
	}
	
	static let url = URL(string:"http://private-d9e5b-oracodechallenge.apiary-mock.com/users/login")!
}


fileprivate extension AuthenticationInfo {
	
	var json: JSONDictionary {
		
		return ["email": email, "password": password]
	}
}
