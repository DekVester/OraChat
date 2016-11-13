//
//  ChatsViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsViewController: UITableViewController {
	
	var chats: [Chat] = [Chat(), Chat()]
	var tableListener: ChatsTableListener?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		guard let tableView = tableView else {exit(1)}

		tableListener = ChatsTableListener(chats: chats, preparingTable: tableView)
		
		weak var weakSelf = self
		tableListener!.select = {
			
			(chat: Chat, index: Int) in

			guard let strongSelf = weakSelf else {return}
			
			let messagesVC = strongSelf.storyboard!.instantiateViewController(withIdentifier: MessagesViewController.storyboardIdentifier)
			strongSelf.show(messagesVC, sender: nil)
		}
	}
}
