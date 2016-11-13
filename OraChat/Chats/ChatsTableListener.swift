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
		}
	}
}
