//
//  TextFieldTableRepresentation.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

typealias TextFieldTableRepresentation = [TextFieldTableRow]

protocol Keyable {
	var key: String {get}
}

extension TextFieldTableRow: Keyable {
	//
}

extension Array where Element: Keyable {

	func elementForKey(_ key: String) -> Element? {

		let indexOrNil = self.index {
			(keyable: Keyable) in
			return keyable.key == key
		}

		guard let index = indexOrNil else {return nil}
		return self[index]
//		return index.map(self.subscript) - compilator crash
	}
}
