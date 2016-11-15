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
		
		super.init(itemSections: [[]], preparingTable: table)
		
		configure = {
			
			(cell: MessageTableCell, message: Message, indexPath: IndexPath) in
			
			cell.contentLabel.text = message.text
			cell.footerLabel.text = message.userDateText
		}
	}
	
	var messages: [Message] {
		
		get {
			return itemSections[0]
		}
		set(newMessages) {
			itemSections[0] = sort(messages: newMessages)
		}
	}
	
	func add(messages newMessages: [Message]) -> [IndexPath] {

		let messages = sort(messages: itemSections[0] + newMessages)
		itemSections[0] = messages
		
		let indexPaths: [IndexPath] = newMessages.map {
			message in
			let row = messages.index(of: message)!
			return IndexPath(row: row, section: 0)
		}
		
		return indexPaths
	}
	
	private func sort(messages: [Message]) -> [Message] {
		
		return messages.sorted {
			messagesPair in
			
			guard let date0 = messagesPair.0.creationDate, let date1 = messagesPair.1.creationDate else {
				
				assertionFailure("Can not use messages without creation date inside the table")
				exit(1)
			}
			
			return date0 < date1
		}
	}
}
