//
//  TableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TableListener<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {

	typealias Configure = (Cell, Item, IndexPath) -> Void
	typealias ConfigureSection = (ItemSection, Int) -> String//only section title is supported for now
	typealias Select = (Item, IndexPath) -> Void
	typealias Refresh = ()->Void
	
	typealias ItemSection = [Item]
	
	init(itemSections someItemSections: [ItemSection], preparingTable aTable: UITableView) {
		
		itemSections = someItemSections
		
		super.init()
		
		aTable.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
		
		aTable.dataSource = self
		aTable.delegate = self
		
		table = aTable
	}
	
	var itemSections: [ItemSection] {
		didSet {
			table?.refreshControl?.endRefreshing()
		}
	}
	
	var configure: Configure!
	var configureSection: ConfigureSection?
	
	var select: Select?
	var refresh: Refresh?
	
	var refreshEnabled = false {
		
		didSet {
			
			if let refreshControl = self.table?.refreshControl {
			
				if refreshControl.isRefreshing {
					refreshControl.endRefreshing()
				}
			}
			
			if refreshEnabled {
				
				let refreshControl = UIRefreshControl()
				refreshControl.addTarget(self, action: #selector(onMore), for: .valueChanged)
				self.table?.refreshControl = refreshControl
			}
			else {
				self.table?.refreshControl = nil
			}
		}
	}
	
	dynamic private func onMore() {

		refresh?()
	}
	
	//MARK:- Cell properties
	
	var cellNib: UINib {
		
		let cellNibName = cellClassName
		let nib = UINib(nibName: cellNibName, bundle: nil)
		return nib
	}
	
	var cellReuseIdentifier: String {
		
		let cellReuseIdentifier = cellClassName
		return cellReuseIdentifier
	}
	
	private let cellClassName = String(describing: Cell.self)

	//MARK:- UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return itemSections.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return configureSection?(itemSections[section], section)
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemSections[section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
		let item = itemSections[indexPath.section][indexPath.row]
		configure(cell, item, indexPath)
		return cell
	}
	
	//MARK:- UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let item = itemSections[indexPath.section][indexPath.row]
		select?(item, indexPath)
	}
	
	weak var table: UITableView?
}
