//
//  Chat+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension Chat: CollectionRequestable {

	/*
	{
		"success": true,
		"data": [
		{
			"id": 1,
			"user_id": 1,
			"name": "A Chat",
			"created": "2016-07-12T04:30:21Z",
			"user": {
				"id": 1,
				"name": "Andre"
			},
			"last_message": {
				"id": 2,
				"user_id": 2,
				"chat_id": 1,
				"message": "Oh hey!",
				"created": "2016-07-16T06:30:21Z",
				"user": {
					"id": 2,
					"name": "Dan"
				}
			}
		},
		{
			"id": 2,
			"user_id": 2,
			"name": "A Chat 2",
			"created": "2016-07-14T12:30:21Z",
			"user": {
				"id": 2,
				"name": "Dan"
			},
			"last_message": {
				"id": 4,
				"user_id": 1,
				"chat_id": 2,
				"message": "Oh man!",
				"created": "2016-07-14T09:30:21Z",
				"user": {
					"id": 1,
					"name": "Andre"
				}
			}
		}],
		"pagination": {
			"page_count": 1,
			"current_page": 1,
			"has_next_page": false,
			"has_prev_page": false,
			"count": 1,
			"limit": null
		}
	}
	*/

	static var dateParseCnt = 0//Remove this when the backend side dates-related flaw is fixed (see the parsing initializer below)
	
	init?(json: JSONDictionary) {

		guard let anId = json["id"] as? Int else {return nil}// - Backend always gives the same ID here - that's why this is not used now
		
		guard let aName = json["name"] as? String else {return nil}
		
		guard let dateString = json["created"] as? String, let aCreationDate = DateFormatter.RFC3339.date(from: dateString) else {return nil}
		
//		id = anId - Backend always gives the same ID here - uncomment this line when this is fixed on the backend side
		id = UUID().uuidString
		
		name = aName
		
		creationDate = type(of:self).dateParseCnt < 2 ? aCreationDate : Date()// - Backend always gives the same date here. Get rid of this workaround when the backend is fixed
		type(of:self).dateParseCnt += 1
		
		if let lastMessageData = json["last_message"] as? JSONDictionary {
			
			guard let aMessage = Message(json: lastMessageData) else {return nil}
			lastMessage = aMessage
		}
		else {
			lastMessage = nil
		}
	}
	
	var json: JSONDictionary {
		
		return ["name": name]
	}
	
	static let domain = "chats"
}
