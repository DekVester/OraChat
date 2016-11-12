//
//  AccountInfo+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension AccountInfo {
	
	static let me = WebResource<AccountInfo>(url: viewUrl) {
		
		json in
		guard let jsonDict = json as? JSONDictionary else { return nil }
		return AccountInfo(json: jsonDict)
	}
	
	private static let viewUrl = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/users/me")!
}

extension AccountInfo {
	
	init?(json: JSONDictionary) {

		guard let jsonData = json["data"] as? JSONDictionary else {return nil}
		guard let email = jsonData["email"] as? String else {return nil}
		guard let aName = jsonData["name"] as? String else {return nil}

		authenticationInfo = AuthenticationInfo(email: email, password: "")
		
		name = aName
		passwordConfirmation = ""
	}
}
