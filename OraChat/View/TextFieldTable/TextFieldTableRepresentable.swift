//
//  TextFieldTableRepresentable.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


protocol TextFieldTableRepresentable {
	
	init(tableRepresentation: TextFieldTableRepresentation)
	func tableRepresentation() -> TextFieldTableRepresentation
}
