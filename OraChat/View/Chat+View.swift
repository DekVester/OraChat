//
//  Chat+View.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/15/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension Chat {
	
	var nameAndAuthorText: String {
		
		var result = name
		
		if let author = author {
			result += " " + NSLocalizedString("by", comment: "Chat") + " " + author
		}
		
		return result
	}

	var lastMessageText: String {
		return lastMessage?.text ?? NSLocalizedString("No messages", comment: "Chat")
	}
	
	var lastUserDateText: String {
		
		guard let lastMessage = lastMessage else {return ""}
		return lastMessage.userDateText
	}
}
