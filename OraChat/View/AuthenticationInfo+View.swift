//
//  AuthenticationInfo+View.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension AuthenticationInfo: TextFieldTableRepresentable {
	
	init(tableRepresentation: TextFieldTableRepresentation) {
	
		let emailOrNil = tableRepresentation.elementForKey(TableRepresentationKey.Email.rawValue)?.value
		let passwordOrNil = tableRepresentation.elementForKey(TableRepresentationKey.Password.rawValue)?.value

		guard let anEmail = emailOrNil else {exit(1)}
		guard let aPassword = passwordOrNil else {exit(1)}
		
		email = anEmail
		password = aPassword
	}
	
	func tableRepresentation() -> TextFieldTableRepresentation {

		var key: TableRepresentationKey = .Email
		var title = NSLocalizedString("Email", comment: "Authorization")
		let emailRow = TextFieldTableRow(key: key.rawValue, title: title, value: email, secure: false)
		
		key = .Password
		title = NSLocalizedString("Password", comment: "Authorization")
		let passwordRow = TextFieldTableRow(key: key.rawValue, title: title, value: password, secure: true)
		
		return [emailRow, passwordRow]
	}
	
	enum TableRepresentationKey: String {
		case Email = "email"
		case Password = "password"
	}
}
