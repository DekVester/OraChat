//
//  Message+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension Message: CollectionRequestable {

	init?(json: JSONDictionary) {
		
		guard let anId = json["id"] as? Int else {return nil}// - Backend always gives the same ID here - that's why this is not used now
		
		guard let aText = json["message"] as? String else {return nil}
		
		guard let user = json["user"] as? JSONDictionary, let name = user["name"] as? String else {return nil}
		
		guard let anUser = json["user"] as? JSONDictionary, let anUserName = anUser["name"] as? String else {return nil}
		
		guard let dateString = json["created"] as? String, let aCreationDate = DateFormatter.RFC3339.date(from: dateString) else {return nil}//Backend always gives the same date here - that's why this is not used now
		
//		id = anId - Backend always gives the same ID here - uncomment this line when this is fixed on the backend side
		id = UUID().uuidString
		
		text = aText
		author = anUserName
		
		creationDate = /*aCreationDate*/Date()// - Backend always gives the same date here. Get rid of this workaround when the backend is fixed
		
		userName = name
	}
	
	var json: JSONDictionary {
		return ["message": text]
	}

	static let domain = "messages"
}
