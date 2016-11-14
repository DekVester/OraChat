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

		tableListener = ChatsTableListener(chats: chats.items, preparingTable: tableView!)
		
		weak var weakSelf = self
		tableListener.select = {
			
			(chat: Chat, index: Int) in

			guard let strongSelf = weakSelf else {return}
			
			let messagesVC = strongSelf.storyboard!.instantiateViewController(withIdentifier: MessagesViewController.storyboardIdentifier)
			strongSelf.show(messagesVC, sender: nil)
		}

		tableListener.refresh = {
			
			guard let strongSelf = weakSelf else {return}
			strongSelf.performRequest(incremental: true)
		}
		
		updateView(prependingChats: nil)
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
			
			strongSelf.latestTask = nil
			
			if var newChats = newChats {

				var prependingChats: PaginatedCollection<Chat>?

				if incremental {
					prependingChats = newChats
					newChats = strongSelf.chats.prepend(collection: newChats)
				}
				
				strongSelf.chats = newChats
				strongSelf.updateView(prependingChats: prependingChats)
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private func updateView(prependingChats: PaginatedCollection<Chat>?) {
		
		guard isViewLoaded else {return}
		
		if let prependingChats = prependingChats {
			
			/*
			Incremental
			*/
			let indexPaths = tableListener.prepend(chats: prependingChats.items)
			tableView.insertRows(at: indexPaths, with: .top)
		}
		else {
			
			/*
			Full reload
			*/
			tableListener.chats = chats.items
			tableView.reloadData()
		}
		
		tableListener.refreshEnabled = chats.pagination.nextPageAvailable
	}

	private var chats = PaginatedCollection<Chat>(domain: nil, id: nil, pagination: Pagination(limit: chatsHunkSize))
	private var query = ""
	private var latestTask: URLSessionDataTask?
	
	private var tableListener: ChatsTableListener!
	
	static private let chatsHunkSize = 10
}
