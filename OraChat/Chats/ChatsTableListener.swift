//
//  ChatsTableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsTableListener: TableListener<Chat, ChatTableCell> {
	
	init(chats someChats: [Chat], preparingTable table: UITableView) {

		super.init(items: someChats, preparingTable: table)
		
		configure = {
			
			(cell: ChatTableCell, chat: Chat, index: Int) in
			cell.textLabel?.text = chat.name
		}
	}
	
	var chats: [Chat] {
		
		get {
			return items
		}
		set(newChats) {
			items = newChats
		}
	}
	
	func prepend(chats prependingChats: [Chat]) -> [IndexPath] {

		items.insert(contentsOf: prependingChats, at: 0)
		
		let range: CountableRange = 0..<prependingChats.count
		
		let indexPaths = range.map {
			IndexPath(row: $0, section: 0)
		}
		
		return indexPaths
	}
}
