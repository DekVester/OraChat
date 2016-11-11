//
//  AuthenticationTableManager.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


enum AuthenticationTableRow {
	case email(String)
	case password(String)
}


class AuthenticationTableManager: TableManager<AuthenticationTableRow, TextFieldCell> {

	typealias AuthenticationInfoChange = (AuthenticationInfo)->Void
	
	var info: AuthenticationInfo
	
	init(table: UITableView, info anInfo: AuthenticationInfo, change: @escaping AuthenticationInfoChange) {
	
		self.info = anInfo
		
		let raws: [AuthenticationTableRow] = [.email(info.email), .password(info.password)]
		super.init(table: table, items: raws)
		
		weak var weakSelf = self
		configure = {
			
			(cell: TextFieldCell, row: AuthenticationTableRow) in
			
			guard let strongSelf = weakSelf else {return}
			
			var text = ""
			var value = ""
			strongSelf.retrieveText(&text, andValue:&value, forRow:row)
			
			cell.label.text = text
			cell.field.text = value
			
			cell.change = {
				
				(newText: String) in
				
				guard let strongSelf = weakSelf else {return}
				
				switch row {
				case .email:
					strongSelf.info.email = newText
				case .password:
					strongSelf.info.password = newText
				}
				
				change(strongSelf.info)
			}
		}
	}

	private func retrieveText(_ text: inout String, andValue value: inout String, forRow row: AuthenticationTableRow) {

		if case let .email(email) = row {
			
			text = "Email"
			value = email
		}
		else {
			
			guard case let .password(password) = row else {exit(1)}
			
			text = "Password"
			value = password
		}
	}
}
