//
//  PaginationInfo.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


struct PaginationInfo {

	let page, limit: Int

	var next: PaginationInfo {
		return PaginationInfo(page: page + 1, limit: limit)
	}
	
	init(limit aLimit: Int) {
		
		page = 0
		limit = aLimit
	}
	
	init(page aPage: Int, limit aLimit: Int) {
		
		page = aPage
		limit = aLimit
	}
}
