//
//  ChatsTableManager.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsTableManager: TableManager<Chat, ChatTableCell> {
	
	init(table: UITableView, chats someChats: [Chat]) {
		
		super.init(table: table, items: someChats)
		
		configure = {
			
			(cell: ChatTableCell, chat: Chat, index: Int) in
		}
	}
}
