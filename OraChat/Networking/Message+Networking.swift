//
//  Message+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension Message: CollectionRequestable {
	
	/*
	{
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
	*/
	static var dateParseCnt = 0//Remove this when the backend side dates-related flaw is fixed (see the parsing initializer below)
	
	init?(json: JSONDictionary) {
		
		guard let anId = json["id"] as? Int else {return nil}// - Backend always gives the same ID here - that's why this is not used now
		
		guard let aText = json["message"] as? String else {return nil}
		
		guard let user = json["user"] as? JSONDictionary, let name = user["name"] as? String else {return nil}
		
		guard let anUser = json["user"] as? JSONDictionary, let anUserName = anUser["name"] as? String else {return nil}
		
		guard let dateString = json["created"] as? String, let aCreationDate = DateFormatter.RFC3339.date(from: dateString) else {return nil}
		
//		id = anId - Backend always gives the same ID here - uncomment this line when this is fixed on the backend side
		id = UUID().uuidString
		
		text = aText
		author = anUserName
		
		creationDate = type(of:self).dateParseCnt < 2 ? aCreationDate : Date()// - Backend always gives the same date here. Get rid of this workaround when the backend is fixed
		type(of:self).dateParseCnt += 1
		
		userName = name
	}
	
	var json: JSONDictionary {
		return ["message": text]
	}

	static let domain = "messages"
}
