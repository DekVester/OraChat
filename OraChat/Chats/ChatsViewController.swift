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
			(chat: Chat, indexPath: IndexPath) in

			guard let strongSelf = self else {return}
			
			let messagesVC = strongSelf.storyboard!.instantiateViewController(withIdentifier: MessagesViewController.storyboardIdentifier) as! MessagesViewController
			
			messagesVC.apply(chat: chat)

			messagesVC.messageAdded = {
				[weak self]
				updatedChat in
				guard let strongSelf = self else {return}

				strongSelf.chats = strongSelf.chats.replace(item: updatedChat)
				strongSelf.updateTableView(addingChats: nil)
			}

			strongSelf.show(messagesVC, sender: nil)
		}

		tableListener.refresh = {
			
			[weak self] in
			guard let strongSelf = self else {return}
			strongSelf.load(incremental: true)
		}
		
		tableListener.search = {
			
			[weak self]
			aQuery in
			guard let strongSelf = self else {return}
			
			strongSelf.query = aQuery
			strongSelf.load(incremental: false)
		}

		updateView()
	}
	
	private func updateView() {
		
		guard isViewLoaded else {return}
		
		updateTableView(addingChats: nil)
		updateWaitView()
	}
	
	private func updateTableView(addingChats: [Chat]?) {
		
		guard isViewLoaded else {return}
		
		if let addingChats = addingChats {
			
			/*
			Incremental
			*/
			var addedSections = IndexSet()
			let addedRows = tableListener.add(chats: addingChats, addingSections: &addedSections)
			
			tableView.beginUpdates()
			
			if addedSections.count > 0 {
				tableView.insertSections(addedSections, with: .automatic)
			}
			tableView.insertRows(at: addedRows, with: .automatic)
			
			tableView.endUpdates()
		}
		else {
			
			/*
			Full reload
			*/
			tableListener.chats = chats.items
			tableView.reloadData()
		}
		
		tableListener.refreshEnabled = chats.pagination.nextPageAvailable || chats.items.count == 0
	}
	
	private func updateWaitView() {
	
		guard isViewLoaded else {return}
		
		if postingTasks.count > 0 && !waitView.isAnimating {
			waitView.startAnimating()
		}
		else if postingTasks.count == 0 && waitView.isAnimating {
			waitView.stopAnimating()
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
		if chats.items.count == 0 {
			load(incremental: false)
		}
	}
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var waitView: UIActivityIndicatorView!
	
	private var tableListener: ChatsTableListener!
	
	//MARK:- Actions
	
	@IBAction private func onAdd() {
		
		let createChatVC = CreateChatTempHelper.controller {
			
			[weak self]
			creatingChat in
			guard let strongSelf = self else {return}
			
			strongSelf.create(chat: creatingChat)
		}
		
		present(createChatVC, animated: true, completion: nil)
	}
	
	//MARK:- Requests
	
	private func create(chat creatingChat: Chat) {

		let postNewChat = chats.new(item: creatingChat)
		
		var task: URLSessionDataTask!
		task = webservice.load(postNewChat) {
			
			[weak self]
			(newChat: Chat?, error: Error?) in
			guard let strongSelf = self else {return}
			
			if let index = strongSelf.postingTasks.index(of: task!) {
				strongSelf.postingTasks.remove(at: index)
			}
			
			if let chat = newChat {
				
				let newChats = strongSelf.chats.add(item: chat)
				strongSelf.chats = newChats
				
				strongSelf.updateTableView(addingChats: [chat])
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
		
		postingTasks.append(task)
	}
	
	private func load(incremental: Bool) {
		
		/*
		(Re-)starts chats request, either incremental or initial
		*/
		if let loadingTask = loadingTask {
			loadingTask.cancel()
		}

		let webResource = incremental ? chats.nextPage(withQuery: query) : chats.firstPage(withQuery: query)

		loadingTask = webservice.load(webResource) {

			[weak self]
			(newChats: PaginatedCollection<Chat>?, error: Error?) in
			guard let strongSelf = self else {return}
			
			strongSelf.loadingTask = nil
			
			if var newChats = newChats {

				var addingChats: PaginatedCollection<Chat>?

				if incremental {
					addingChats = newChats
					newChats = strongSelf.chats.add(collection: newChats)
				}
				
				strongSelf.chats = newChats
				strongSelf.updateTableView(addingChats: addingChats?.items)
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private var postingTasks: [URLSessionDataTask] = [] {
	
		didSet {
			updateWaitView()
		}
	}
	
	private var loadingTask: URLSessionDataTask?
	
	private var chats = PaginatedCollection<Chat>(parentDomain: nil, id: nil, pagination: Pagination(limit: chatsHunkSize))
	private var query = ""
	
	static private let chatsHunkSize = 10
	
	deinit {
		
		/*
		Cancel all network calls
		*/
		postingTasks.forEach {
			$0.cancel()
		}
		loadingTask?.cancel()
	}
}
