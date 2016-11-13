//
//  Chat+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension Chat {
	
	static let all = WebResource<[Chat]>(path: listUrlPath, method: .get) {
		
		json in
		
		guard let dictionaries = json as? [JSONDictionary] else {return nil}
		return dictionaries.flatMap(Chat.init)
	}
	
	private static let listUrlPath = "chats"//q=q&page=page&limit=limit
}

extension Chat: JSONSerializable {
	
	init?(json: JSONDictionary) {
	}
	
	var json: JSONDictionary {
		return ["":""]
	}
}
