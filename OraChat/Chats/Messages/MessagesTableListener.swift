//
//  MessagesTableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class MessagesTableListener: TableListener <Message, MessageTableCell> {

	init(preparingTable table: UITableView) {
		
		super.init(items: [], preparingTable: table)
		
		configure = {
			
			(cell: MessageTableCell, message: Message, index: Int) in
			cell.textLabel?.text = message.text
		}
	}
	
	var messages: [Message] {
		
		get {
			return items
		}
		set(newMessages) {
			items = newMessages
		}
	}
	
	func prepend(messages prependingMessages: [Message]) -> [IndexPath] {
		
		items.insert(contentsOf: prependingMessages, at: 0)
		
		let range: CountableRange = 0..<prependingMessages.count
		
		let indexPaths = range.map {
			IndexPath(row: $0, section: 0)
		}
		
		return indexPaths
	}
}
