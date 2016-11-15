//
//  ChatsTableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class ChatsTableListener: TableListener<Chat, ChatTableCell>, UISearchBarDelegate {
	
	init(preparingTable table: UITableView) {

		super.init(items: [], preparingTable: table)
		
		guard let searchBar = searchBar else {exit(1)}
		searchBar.delegate = self

		configure = {
			
			(cell: ChatTableCell, chat: Chat, index: Int) in
			cell.textLabel?.text = chat.name
		}
	}
	
	var chats: [Chat] {
		
		get {
			return items
		}
		set(newChats) {
			items = newChats
		}
	}
	
	func prepend(chats prependingChats: [Chat]) -> [IndexPath] {

		items.insert(contentsOf: prependingChats, at: 0)
		
		let range: CountableRange = 0..<prependingChats.count
		
		let indexPaths = range.map {
			IndexPath(row: $0, section: 0)
		}
		
		return indexPaths
	}
	
	//MARK:- Search Bar

	typealias Search = (String) -> Void

	var search: Search?

	/*
	Consider to use this for search
	*/
//	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//		
//		search?(searchText)
//	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		if let searchText = searchBar.text {
			search?(searchText)
		}
		
		searchBar.resignFirstResponder()
	}
	
	private weak var searchBar: UISearchBar? {
		return table?.tableHeaderView as? UISearchBar
	}
}
