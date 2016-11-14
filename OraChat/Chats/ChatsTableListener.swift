//
//  ChatsTableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsTableListener: TableListener<Chat, ChatTableCell> {
	
	init(chats someChats: [Chat], hasMore more: Bool, preparingTable table: UITableView) {
		
		hasMore = more
		
		super.init(items: someChats, preparingTable: table)
		
		configure = {
			
			(cell: ChatTableCell, chat: Chat, index: Int) in
		}
	}
	
	var chats: [Chat] {
		return items
	}
	
	func set(chats newChats: [Chat], hasMore more: Bool) {
		items = newChats
		hasMore = more
	}
	
	func append(chats appendingChats: [Chat], hasMore more: Bool) -> [IndexPath] {

		let firstIndex = items.count
		
		items.append(contentsOf: appendingChats)
		hasMore = more
		
		let count = items.count
		let range: CountableRange = firstIndex..<count
		
		let indexPaths = range.map {
			IndexPath(row: $0, section: 0)
		}
		return indexPaths
	}
	
	private var hasMore: Bool
}
