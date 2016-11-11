//
//  ChatsViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsViewController: UITableViewController {
	
	var chats: [Chat] = []
	var tableManager: ChatsTableManager?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		guard let tableView = tableView else {exit(1)}

		tableManager = ChatsTableManager(table: tableView, chats: chats)
		tableManager!.select = {
		}
	}
}
