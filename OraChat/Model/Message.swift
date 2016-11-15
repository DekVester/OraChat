//
//  Message.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

struct Message {

	let id: String?
	let text: String
	let author: String?
	let creationDate: Date?
	let userName: String?
	
	init(text aText: String) {
		
		text = aText
		
		id = nil
		author = nil
		creationDate = nil
		userName = nil
	}
}

extension Message: Equatable {
	
	public static func ==(lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}
}
