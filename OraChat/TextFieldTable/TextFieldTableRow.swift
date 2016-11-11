//
//  TextFieldTableRow.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

struct TextFieldTableRow {
	
	let key: String
	let title: String
	let value: String
	
	func replaceValue(newValue: String) -> TextFieldTableRow {
		
		return TextFieldTableRow(key: key, title: title, value: newValue)
	}
}
