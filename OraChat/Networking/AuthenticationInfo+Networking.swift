//
//  AuthenticationInfo+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension AuthenticationInfo {
	
	var login: WebResource<Bool> {
		
		let loginResource = WebResource<Bool>(url: type(of: self).url) {
			
			json in
			guard let jsonDict = json as? JSONDictionary else {return false}
			return jsonDict["success"] as? Bool ?? false
		}
		
		return loginResource
	}
	
	static let url = URL(string:"http://private-d9e5b-oracodechallenge.apiary-mock.com/users/login")!
}
