//
//  ChatsViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
	
	//MARK:- View
	
	override func viewDidLoad() {
		
		super.viewDidLoad()

		tableListener = ChatsTableListener(preparingTable: tableView)

		tableListener.select = {

			[weak self]
			(chat: Chat, index: Int) in

			guard let strongSelf = self else {return}
			
			let messagesVC = strongSelf.storyboard!.instantiateViewController(withIdentifier: MessagesViewController.storyboardIdentifier) as! MessagesViewController
			messagesVC.chat = chat

			strongSelf.show(messagesVC, sender: nil)
		}

		tableListener.refresh = {
			
			[weak self] in
			guard let strongSelf = self else {return}
			strongSelf.performRequest(incremental: true)
		}
		
		tableListener.search = {
			
			[weak self]
			aQuery in
			guard let strongSelf = self else {return}
			
			strongSelf.query = aQuery
			strongSelf.performRequest(incremental: false)
		}
		
		updateView(prependingChats: nil)
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if chats.items.count == 0 {
			performRequest(incremental: false)
		}
	}
	
	@IBOutlet private weak var tableView: UITableView!
	private var tableListener: ChatsTableListener!
	
	//MARK:- Actions
	
	@IBAction private func onAdd() {
		
	}
	
	//MARK:- Request
	
	private func performRequest(incremental: Bool) {
		
		/*
		(Re-)starts chats request, either incremental or initial
		*/
		if let latestTask = latestTask {
			latestTask.cancel()
		}

		let webResource = incremental ? chats.nextPage(withQuery: query) : chats.firstPage(withQuery: query)

		latestTask = webservice.load(webResource) {

			[weak self]
			(newChats: PaginatedCollection<Chat>?, error: Error?) in
			guard let strongSelf = self else {return}
			
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
	
	private var latestTask: URLSessionDataTask?
	
	private var chats = PaginatedCollection<Chat>(parentDomain: nil, id: nil, pagination: Pagination(limit: chatsHunkSize))
	private var query = ""
	
	static private let chatsHunkSize = 10
}
