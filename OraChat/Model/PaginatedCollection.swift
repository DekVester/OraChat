//
//  PaginatedCollection.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


struct PaginatedCollection<Item: Equatable> {

	let parentDomain: String?
	let id: String?
	
	let items: [Item]
	let pagination: Pagination
	
	init(parentDomain domain: String?, id anId: String?, pagination aPagination: Pagination) {

		parentDomain = domain
		id = anId
		items = []
		pagination = aPagination
	}
	
	func add(item: Item) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(original: self, appendingItem: item)
	}

	func add(collection: PaginatedCollection<Item>) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(left: self, right: collection)
	}
	
	func replace(item: Item) -> PaginatedCollection<Item> {
		return PaginatedCollection<Item>(original: self, replacingItem: item)
	}

	private init(original: PaginatedCollection<Item>, replacingItem item: Item) {
		
		parentDomain = original.parentDomain
		id = original.id
		pagination = original.pagination
		
		guard let itemIndex = original.items.index(of: item) else {
			items = original.items
			return
		}
		
		var newItems = original.items
		newItems[itemIndex] = item
		
		items = newItems
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
