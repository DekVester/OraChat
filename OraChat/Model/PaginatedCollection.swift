//
//  PaginatedCollection.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


struct PaginatedCollection<Item> {

	let domain: String?
	let id: Int?
	
	let items: [Item]
	let pagination: Pagination
	
	init(domain aDomain: String?, id anId: Int?, pagination aPagination: Pagination) {
		
		domain = aDomain
		id = anId
		items = []
		pagination = aPagination
	}
	
	func append(collection: PaginatedCollection<Item>) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(left: self, right: collection)
	}
	
	func prepend(collection: PaginatedCollection<Item>) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(left: collection, right: self)
	}
	
	private init(left: PaginatedCollection<Item>, right: PaginatedCollection<Item>) {
		
		assert(left.domain == right.domain && left.id == right.id, "Collections being concatenated must be of the same domain and identifier")
		
		domain = left.domain
		id = left.id
		
		items = left.items + right.items
		pagination = max(left.pagination, right.pagination)
	}
}
