//
//  Chat.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

struct Chat {
	
	let id: String?
	let name: String
	let author: String?
	let creationDate: Date?
	let lastMessage: Message?
	
	init(name aName: String) {
		
		name = aName
		
		id = nil
		author = nil
		creationDate = nil
		lastMessage = nil
	}
	
	func setLast(message: Message) -> Chat {
		return Chat(original: self, lastMessage: message)
	}
	
	private init(original: Chat, lastMessage theLastMessage: Message) {
		
		name = original.name
		id = original.id
		author = original.author
		creationDate = original.creationDate
		lastMessage = theLastMessage
	}
}

extension Chat: Equatable {
	
	public static func ==(lhs: Chat, rhs: Chat) -> Bool {
		return lhs.id == rhs.id
	}
}
