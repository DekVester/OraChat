//
//  Pagination+Json.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/14/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

extension Pagination {
	
	init?(json: JSONDictionary, limit aLimit: Int) {
		
		guard let currentPage = json["current_page"] as? Int else {return nil}
		guard let next = json["has_next_page"] as? Bool else {return nil}
		
		page = currentPage
		limit = aLimit
		nextPageAvailable = next
	}
}
