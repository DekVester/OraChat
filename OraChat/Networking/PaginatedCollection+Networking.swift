//
//  PaginatedCollection+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

//MARK:- List

extension PaginatedCollection where Item: CollectionRequestable {
	
	func firstPage(withQuery query: String = "") -> WebResource<PaginatedCollection<Item>> {
		return page(next: false, withQuery: query)
	}
	
	func nextPage(withQuery query: String = "") -> WebResource<PaginatedCollection<Item>> {
		return page(next: true, withQuery: query)
	}
	
	private func page(next: Bool, withQuery query: String) -> WebResource<PaginatedCollection<Item>> {
		
		let path = urlPath + Item.domain + "?" + paginationParameters(next) + andQueryParameterFor(query)
		
		let resource = WebResource<PaginatedCollection<Item>>(path: path) {
			
			json in

			guard let jsonData = json as? JSONDictionary else {return nil}
			return PaginatedCollection<Item>(json: jsonData, originalCollection: self)
		}
		
		return resource
	}

	private init?(json: JSONDictionary, originalCollection collection: PaginatedCollection<Item>) {
		
		guard let paginationData = json["pagination"] as? JSONDictionary, let newPagination = Pagination(json: paginationData, limit: collection.pagination.limit) else {return nil}
		
		guard let itemsData = json["data"] as? [JSONDictionary] else {return nil}
		
		let newPageItems = itemsData.flatMap {
			return Item(json: $0)
		}
		
		self.init(originalCollection: collection, items: newPageItems, pagination: newPagination)
	}
	
	private init(originalCollection collection: PaginatedCollection<Item>, items newItems: [Item], pagination newPagination: Pagination) {
		
		parentDomain = collection.parentDomain
		id = collection.id
		
		items = newItems
		pagination = newPagination
	}
	
	private func paginationParameters(_ nextPage: Bool) -> String {
		
		let page = nextPage ? pagination.page + 1 : 1
		return "page=\(page)&limit=\(pagination.limit)"
	}
	
	private func andQueryParameterFor(_ query: String) -> String {
		
		let parameter = query.isEmpty ? "" : "&q=\(query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)"
		return parameter
	}
}

//MARK:- Creation

extension PaginatedCollection where Item: CollectionRequestable {
	
	func new(item: Item) -> WebResource<Item> {
		
		let path = urlPath + Item.domain
		let resource = WebResource<Item>(path: path, method: .post(item.json)) {
			
			json in
			guard let jsonData = json as? JSONDictionary else {return nil}
			guard let itemData = jsonData["data"] as? JSONDictionary else {return nil}
			
			return Item(json: itemData)
		}
		
		return resource
	}
}


fileprivate extension PaginatedCollection {
	
	var urlPath: String {
		
		var domainSubpath = parentDomain ?? ""
		if !domainSubpath.isEmpty {
			domainSubpath += "/"
		}
		
		var idSubpath = id != nil ? "\(id!)" : ""
		if !idSubpath.isEmpty {
			idSubpath += "/"
		}
		
		return domainSubpath + idSubpath
	}
}
