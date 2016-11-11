//
//  TextFieldCell.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

typealias TextFieldChange = (String)->Void

class TextFieldCell: UITableViewCell {

	var change: TextFieldChange?
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var field: UITextField!
}

extension TextFieldCell: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
	
		let currentText = (textField.text ?? "") as NSString
		let newText = currentText.replacingCharacters(in: range, with: string) as String
		change?(newText)
		
		return true
	}
}
