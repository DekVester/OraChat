//
//  ChatsViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsViewController: UITableViewController {
	
	override func viewDidLoad() {
		
		super.viewDidLoad()

		tableListener = ChatsTableListener(chats: chats, preparingTable: tableView!)
		
		weak var weakSelf = self
		tableListener.select = {
			
			(chat: Chat, index: Int) in

			guard let strongSelf = weakSelf else {return}
			
			let messagesVC = strongSelf.storyboard!.instantiateViewController(withIdentifier: MessagesViewController.storyboardIdentifier)
			strongSelf.show(messagesVC, sender: nil)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		weak var weakSelf = self
		webservice.load(Chat.allWith(query: query, page: pagination.page, limit: pagination.limit)) {

			(chats: [Chat]?, error: Error?) in
			guard let strongSelf = weakSelf else {return}
				
			if let chats = chats {
				
				strongSelf.chats = chats
				strongSelf.updateView()
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private func updateView() {
		
		guard isViewLoaded else {return}
		
		tableListener.chats = chats
		tableView.reloadData()
	}
	
	private var chats: [Chat] = []
	private var query = ""
	private var pagination = PaginationInfo(limit: chatsHunkSize)
	
	private var tableListener: ChatsTableListener!
	
	static private let chatsHunkSize = 10
}
