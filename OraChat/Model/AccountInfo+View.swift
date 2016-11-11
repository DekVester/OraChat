//
//  AccountInfo+View.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension AccountInfo: TextFieldTableRepresentable {
	
	init(tableRepresentation: TextFieldTableRepresentation) {

		let nameOrNil = tableRepresentation.elementForKey(TableRepresentationKey.Name.rawValue)?.value
		let passwordOrNil = tableRepresentation.elementForKey(TableRepresentationKey.PasswordConfirmation.rawValue)?.value
		
		guard let aName = nameOrNil else {exit(1)}
		guard let aPassword = passwordOrNil else {exit(1)}
		
		name = aName
		passwordConfirmation = aPassword
		
		authenticationInfo = AuthenticationInfo(tableRepresentation: tableRepresentation)
	}
	
	func tableRepresentation() -> TextFieldTableRepresentation {

		var key: TableRepresentationKey = .Name
		var title = NSLocalizedString("Name", comment: "Authorization")
		let nameRow = TextFieldTableRow(key: key.rawValue, title: title, value: name, secure: false)
		
		key = .PasswordConfirmation
		title = NSLocalizedString("Confirmation", comment: "Authorization")
		let confirmationRow = TextFieldTableRow(key: key.rawValue, title: title, value: passwordConfirmation, secure: true)

		let authenticationData = authenticationInfo.tableRepresentation()
		let emailRow = authenticationData.elementForKey(AuthenticationInfo.TableRepresentationKey.Email.rawValue)!
		let passwordRow = authenticationData.elementForKey(AuthenticationInfo.TableRepresentationKey.Password.rawValue)!
		
		return [nameRow, emailRow, passwordRow, confirmationRow]
	}
	
	enum TableRepresentationKey: String {
		case Name = "name"
		case PasswordConfirmation = "passwordConfirmation"
	}
}
