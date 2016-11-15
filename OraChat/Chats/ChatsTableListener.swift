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

		super.init(itemSections: [[]], preparingTable: table)
		
		guard let searchBar = searchBar else {exit(1)}
		searchBar.delegate = self

		configureSection = {
			(section: ItemSection, index: Int) in
			
			guard let date = section.first?.creationDate else {
				assertionFailure("Invalid chat inside the table")
				exit(1)
			}
			
			return DateFormatter.visualization.string(from: date)
		}

		configure = {
			(cell: ChatTableCell, chat: Chat, indexPath: IndexPath) in
			cell.textLabel?.text = chat.name
		}
	}
	
	var chats: [Chat] {
		
		get {
			return itemSections.flatMap {return $0}
		}
		set(newChats) {
			itemSections = sort(chats: newChats)
		}
	}
	
	func add(chats addingChats: [Chat], addingSections: inout IndexSet) -> [IndexPath] {

		chats += addingChats
		
		/*
		Calculate indices paths of the new chats that have just been added
		*/
		let indexPaths: [IndexPath] = addingChats.map {
			chat in
			
			let sectionIndex = itemSections.index {
				(section: ItemSection) in
				return section.contains {$0 == chat}
			}!
			
			let chatIndex = itemSections[sectionIndex].index(of: chat)!
			
			let indexPath = IndexPath(row: chatIndex, section: sectionIndex)
			return indexPath
		}
		
		/*
		Calculate indices of inserted sections
		*/
		let newSections: [Int] = indexPaths.flatMap {

			(path: IndexPath) in
			
			let sectionIndex = path.section
			let newSection = itemSections[sectionIndex].count == 1
			return newSection ? sectionIndex : nil
		}

		addingSections = IndexSet(newSections)
		return indexPaths
	}
	
	private func sort(chats: [Chat]) -> [ItemSection] {

		let distinctSortedDays = Set(chats.map {
			return creationDay(chat: $0)
		}).sorted()

		let sections: [ItemSection] = distinctSortedDays.map {
			day in
			let chatsForDay = chats.filter {creationDay(chat: $0) == day}
				.sorted {return compareChats($0, $1)}
			return chatsForDay
		}
		
		return sections
	}
	
	private func creationDay(chat: Chat) -> Date {

		guard let date = chat.creationDate else {
			assertionFailure("Can not use chats without creation date inside the table")
			exit(1)
		}
		
		return currentCalendar.startOfDay(for: date)
	}
	
	private func compareChats(_ lhs: Chat, _ rhs: Chat) -> Bool {
		
		guard let lhsDate = lhs.creationDate, let rhsDate = rhs.creationDate else {
			assertionFailure("Can not use chats without creation date inside the table")
			exit(1)
		}
		
		return lhsDate < rhsDate
	}
	
	private let currentCalendar = Calendar.current
	
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
