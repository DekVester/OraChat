//
//  AccountInfo.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

struct AccountInfo {
	
	let authenticationInfo: AuthenticationInfo
	let name: String
	let passwordConfirmation: String
	
	init() {
		
		authenticationInfo = AuthenticationInfo()
		name = ""
		passwordConfirmation = ""
	}
}
