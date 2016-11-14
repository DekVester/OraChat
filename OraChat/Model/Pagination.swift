//
//  Pagination.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


struct Pagination {

	let page, limit: Int
	let nextPageAvailable: Bool

	init(limit aLimit: Int) {
		
		page = 0
		limit = aLimit
		nextPageAvailable = true
	}
}

extension Pagination: Comparable {
	
	public static func <=(lhs: Pagination, rhs: Pagination) -> Bool {
		return lhs < rhs || lhs == rhs
	}
	
	public static func >=(lhs: Pagination, rhs: Pagination) -> Bool {
		return !(lhs < rhs)
	}

	public static func >(lhs: Pagination, rhs: Pagination) -> Bool{
		return !(lhs <= rhs)
	}
	
	public static func <(lhs: Pagination, rhs: Pagination) -> Bool{
		return lhs.page < rhs.page
	}
	
	public static func ==(lhs: Pagination, rhs: Pagination) -> Bool {
		return lhs.page == rhs.page
	}
}
