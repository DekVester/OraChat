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
			strongSelf.load(incremental: true)
		}
		
		tableListener.search = {
			
			[weak self]
			aQuery in
			guard let strongSelf = self else {return}
			
			strongSelf.query = aQuery
			strongSelf.load(incremental: false)
		}
		
		updateView(prependingChats: nil)
	}
	
	private func updateView(prependingChats: PaginatedCollection<Chat>?) {
		
		guard isViewLoaded else {return}
		
		updateTableView(prependingChats: prependingChats)
		updateWaitView()
	}
	
	private func updateTableView(prependingChats: PaginatedCollection<Chat>?) {
		
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
		
//		show(createChatVC, sender: nil)
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
				
				let newChats = strongSelf.chats.append(item: chat)
				strongSelf.chats = newChats
				
				strongSelf.updateTableView(prependingChats: nil)
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

				var prependingChats: PaginatedCollection<Chat>?

				if incremental {
					prependingChats = newChats
					newChats = strongSelf.chats.prepend(collection: newChats)
				}
				
				strongSelf.chats = newChats
				strongSelf.updateTableView(prependingChats: prependingChats)
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
}
