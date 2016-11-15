//
//  PaginatedCollection.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


struct PaginatedCollection<Item> {

	let parentDomain: String?
	let id: Int?
	
	let items: [Item]
	let pagination: Pagination
	
	init(parentDomain domain: String?, id anId: Int?, pagination aPagination: Pagination) {

		parentDomain = domain
		id = anId
		items = []
		pagination = aPagination
	}
	
	func append(item: Item) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(original: self, appendingItem: item)
	}
	
	func append(collection: PaginatedCollection<Item>) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(left: self, right: collection)
	}
	
	func prepend(collection: PaginatedCollection<Item>) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(left: collection, right: self)
	}
	
	private init(original: PaginatedCollection<Item>, appendingItem item: Item) {
		
		parentDomain = original.parentDomain
		id = original.id
		items = original.items + [item]
		pagination = original.pagination
	}
	
	private init(left: PaginatedCollection<Item>, right: PaginatedCollection<Item>) {
		
		assert(left.parentDomain == right.parentDomain && left.id == right.id, "Collections being concatenated must be of the same domain and identifier")
		
		parentDomain = left.parentDomain
		id = left.id
		
		items = left.items + right.items
		pagination = max(left.pagination, right.pagination)
	}
}
