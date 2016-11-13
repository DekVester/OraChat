//
//  AccountInfo+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension AccountInfo {
	
	var register: WebResource<AuthorizationToken> {
		
		let registerResource = WebResource<AuthorizationToken>(url: type(of: self).registerUrl, method: .post(json)) {
			
			json in
			guard let jsonDict = json as? JSONDictionary else {return nil}
			guard let jsonData = jsonDict["data"] as? JSONDictionary else {return nil}
			return jsonData["token"] as? AuthorizationToken
		}
		
		return registerResource
	}
	
	static let me = WebResource<AccountInfo>(url: viewUrl) {
		
		json in
		guard let jsonDict = json as? JSONDictionary else { return nil }
		return AccountInfo(json: jsonDict)
	}
	
	private static let viewUrl = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/users/me")!
	private static let registerUrl = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/users/register")!
}

extension AccountInfo: JSONSerializable {
	
	init?(json: JSONDictionary) {

		guard let jsonData = json["data"] as? JSONDictionary else {return nil}
		guard let aName = jsonData["name"] as? String else {return nil}
		guard let authInfo = AuthenticationInfo(json: json) else {return nil}
		
		name = aName
		passwordConfirmation = ""
		authenticationInfo = authInfo
	}
	
	var json: JSONDictionary {
		
		var jsonDict: JSONDictionary = ["name": name, "confirm": passwordConfirmation]
		
		let authJsonDict = authenticationInfo.json
		authJsonDict.forEach {
			
			(pair: (key: String, value: Any)) in
			jsonDict[pair.key] = pair.value
		}
		
		return jsonDict
	}
}
