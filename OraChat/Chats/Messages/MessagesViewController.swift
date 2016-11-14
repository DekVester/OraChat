//
//  MessagesViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
	
	static let storyboardIdentifier = String(describing: MessagesViewController.self)
	
	var chat: Chat! {
		
		willSet(newChat) {
			guard let _ = newChat else {exit(1)}//once setup, the chat can not be reset - only changed to another one
		}
		
		didSet {

			messages = PaginatedCollection<Message>(domain: Chat.listUrlPath, id: chat.id, pagination: Pagination(limit: MessagesViewController.messagesHunkSize))
			performRequest(incremental: false)
		}
	}
	
	private var messages: PaginatedCollection<Message>!

	static private let messagesHunkSize = 20
	
	//MARK:- Requests
	
	private func performRequest(incremental: Bool) {
		
		/*
		Cancel current request, if there's any
		*/
		cancelRequest()

		/*
		Perform a new request
		*/
		let webResource = incremental ? messages.nextPage(withQuery: "") : messages.firstPage(withQuery: "")
		
		weak var weakSelf = self
		networkTask = webservice.load(webResource) {
			
			(newMessages: PaginatedCollection<Message>?, error: Error?) in
			guard let strongSelf = weakSelf else {return}
			
			strongSelf.networkTask = nil
			
			if var newMessages = newMessages {
				
				var prependingMessages: PaginatedCollection<Message>?
				
				if incremental {
					prependingMessages = newMessages
					newMessages = strongSelf.messages.prepend(collection: newMessages)
				}
				
				strongSelf.messages = newMessages
				strongSelf.updateView(prependingMessages: prependingMessages)
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private func cancelRequest() {
		
		if let task = networkTask {
			task.cancel()
			networkTask = nil
		}
	}
	
	private var networkTask: URLSessionTask?
	
	//MARK:- Views
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		tableListener = MessagesTableListener(preparingTable: tableView!)
		
		weak var weakSelf = self
		tableListener.refresh = {
			
			guard let strongSelf = weakSelf else {return}
			strongSelf.performRequest(incremental: true)
		}
		
		updateView(prependingMessages: nil)
	}
	
	private func updateView(prependingMessages: PaginatedCollection<Message>?) {
		
		guard isViewLoaded else {return}

		if let prependingMessages = prependingMessages {
			
			/*
			Incremental
			*/
			let indexPaths = tableListener.prepend(messages: prependingMessages.items)
			tableView.insertRows(at: indexPaths, with: .top)
		}
		else {
			
			/*
			Full reload
			*/
			tableListener.messages = messages.items
			tableView.reloadData()
		}
		
		tableListener.refreshEnabled = messages.pagination.nextPageAvailable
	}
	
	private var tableListener: MessagesTableListener!
	
	//MARK:- Deinit
	
	deinit {
		cancelRequest()
	}
}
