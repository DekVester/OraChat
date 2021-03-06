//
//  MessagesViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
	
	static let storyboardIdentifier = String(describing: MessagesViewController.self)

	func apply(chat aChat: Chat) {
		
		chat = aChat

		title = chat.name
		
		/*
		Request messages
		*/
		messages = PaginatedCollection<Message>(parentDomain: Chat.domain, id: chat.id, pagination: Pagination(limit: MessagesViewController.messagesHunkSize))
		load(incremental: false)
	}
	
	private(set) var chat: Chat!
	
	private var messages: PaginatedCollection<Message>!

	static private let messagesHunkSize = 20
	
	//MARK:- Actions
	
	@IBAction private func onAdd() {
		
		let createMessageVC = CreateMessageTempHelper.controller {
			
			[weak self]
			creatingMessage in
			guard let strongSelf = self else {return}
			
			strongSelf.create(message: creatingMessage)
		}
		
		present(createMessageVC, animated: true, completion: nil)
	}
	
	var messageAdded: ((Chat) -> Void)!
	
	//MARK:- Requests
	
	private func create(message creatingMessage: Message) {
		
		let postNewMessage = messages.new(item: creatingMessage)
		
		var task: URLSessionDataTask!
		task = webservice.load(postNewMessage) {
			
			[weak self]
			(newMessage: Message?, error: Error?) in
			guard let strongSelf = self else {return}
			
			if let index = strongSelf.postingTasks.index(of: task!) {
				strongSelf.postingTasks.remove(at: index)
			}
			
			if let message = newMessage {
				
				let newMessages = strongSelf.messages.add(item: message)
				strongSelf.messages = newMessages
				
				strongSelf.updateTableView(addingMessages: [message], scrollToLast: true)
				strongSelf.updateChatLastMessageAndNotify()
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
		
		postingTasks.append(task)
	}
	
	private func load(incremental: Bool) {
		
		/*
		Cancel current request, if there's any
		*/
		cancelLoadingRequest()

		/*
		Perform a new request
		*/
		let webResource = incremental ? messages.nextPage(withQuery: "") : messages.firstPage(withQuery: "")
		
		loadingTask = webservice.load(webResource) {
		
			[weak self]
			(newMessages: PaginatedCollection<Message>?, error: Error?) in
			guard let strongSelf = self else {return}
			
			strongSelf.loadingTask = nil
			
			if var newMessages = newMessages {
				
				var addingMessages: PaginatedCollection<Message>?
				
				if incremental {
					addingMessages = newMessages
					newMessages = strongSelf.messages.add(collection: newMessages)
				}
				
				strongSelf.messages = newMessages
				strongSelf.updateTableView(addingMessages: addingMessages?.items)
				
				strongSelf.updateChatLastMessageAndNotify()
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private func updateChatLastMessageAndNotify() {
		
		/*
		Sync chat last message with the collection one
		*/
		if let message = latestMessage, chat.lastMessage != message {
			chat = chat.setLast(message: message)
			messageAdded(chat)
		}
	}
	
	private var latestMessage: Message? {
		
		return messages.items.sorted {
			(message0: Message, message1: Message) in
			guard let date0 = message0.creationDate, let date1 = message1.creationDate else {
				assertionFailure("Invalid messages")
				exit(1)
			}
			return date0 < date1
		}.last
	}
	
	private func cancelLoadingRequest() {
		
		if let task = loadingTask {
			task.cancel()
			loadingTask = nil
		}
	}
	
	private var postingTasks: [URLSessionDataTask] = [] {		
		didSet {
			updateWaitView()
		}
	}
	
	private var loadingTask: URLSessionTask?
	
	//MARK:- Views
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		tableListener = MessagesTableListener(preparingTable: tableView)

		tableListener.refresh = {
			
			[weak self] in
			guard let strongSelf = self else {return}
			strongSelf.load(incremental: true)
		}
		
		updateView()
	}
	
	private func updateView() {
		
		guard isViewLoaded else {return}

		updateTableView(addingMessages: nil)
		updateWaitView()
	}
	
	private func updateTableView(addingMessages: [Message]?, scrollToLast: Bool = false) {
		
		guard isViewLoaded else {return}
		
		if let addingMessages = addingMessages {
			
			/*
			Incremental
			*/
			let indexPaths = tableListener.add(messages: addingMessages)
			tableView.insertRows(at: indexPaths, with: .automatic)
		}
		else {
			
			/*
			Full reload
			*/
			tableListener.messages = messages.items
			tableView.reloadData()
		}
		
		tableListener.refreshEnabled = messages.pagination.nextPageAvailable || messages.items.count == 0
		
		if scrollToLast {
			
			let lastIndex = messages.items.count - 1
			if lastIndex >= 0 {
				let last = IndexPath(row: lastIndex, section: 0)
				tableView.scrollToRow(at: last, at: .bottom, animated: true)
			}
		}
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
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var waitView: UIActivityIndicatorView!
	
	private var tableListener: MessagesTableListener!
	
	//MARK:- Deinit
	
	deinit {
		
		/*
		Cancel all network tasks
		*/
		postingTasks.forEach {
			$0.cancel()
		}
		cancelLoadingRequest()
	}
}
