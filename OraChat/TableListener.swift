//
//  TableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TableListener<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {

	typealias Configure = (Cell, Item, Int) -> Void
	typealias Select = (Item, Int) -> Void
	typealias Refresh = ()->Void
	
	init(items someItems: [Item], preparingTable aTable: UITableView) {
		
		items = someItems
		
		super.init()
		
		aTable.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)
		
		aTable.dataSource = self
		aTable.delegate = self
		
		table = aTable
	}
	
	var items: [Item] {
		didSet {
			table?.refreshControl?.endRefreshing()
		}
	}
	
	var configure: Configure!
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
		let row = indexPath.row
		let item = items[row]
		configure(cell, item, row)
		return cell
	}
	
	//MARK:- UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let row = indexPath.row
		let item = items[row]
		select?(item, row)
	}
	
	weak var table: UITableView?
}
