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

		tableListener = ChatsTableListener(chats: chats.items, hasMore: chats.pagination.nextPageAvailable, preparingTable: tableView!)
		
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

		if chats.items.count == 0 {
			performRequest(incremental: false)
		}
	}
	
	private func performRequest(incremental: Bool) {
		
		/*
		(Re-)starts chats request, either incremental or initial
		*/
		if let latestTask = latestTask {
			latestTask.cancel()
		}

		let webResource = incremental ? chats.nextPage(withQuery: query) : chats.firstPage(withQuery: query)
		
		weak var weakSelf = self
		latestTask = webservice.load(webResource) {
			
			(newChats: PaginatedCollection<Chat>?, error: Error?) in
			guard let strongSelf = weakSelf else {return}
			
			if var newChats = newChats {

				var appendingChats: PaginatedCollection<Chat>?

				if incremental {
					appendingChats = newChats
					newChats = strongSelf.chats.append(collection: newChats)
				}
				
				strongSelf.chats = newChats
				strongSelf.updateView(appendingChats: appendingChats)
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private func updateView(appendingChats: PaginatedCollection<Chat>?) {
		
		guard isViewLoaded else {return}
		
		if let appendingChats = appendingChats {
			
			/*
			Incremental
			*/
			let indexPaths = tableListener.append(chats: appendingChats.items, hasMore: self.chats.pagination.nextPageAvailable)
			tableView.insertRows(at: indexPaths, with: .bottom)
		}
		else {
			
			/*
			Full reload
			*/
			tableListener.set(chats: self.chats.items, hasMore: self.chats.pagination.nextPageAvailable)
			tableView.reloadData()
		}
	}

	private var chats = PaginatedCollection<Chat>(domain: nil, id: nil, pagination: Pagination(limit: chatsHunkSize))
	private var query = ""
	private var latestTask: URLSessionDataTask?
	
	private var tableListener: ChatsTableListener!
	
	static private let chatsHunkSize = 10
}
