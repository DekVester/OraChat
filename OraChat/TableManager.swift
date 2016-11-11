//
//  TableManager.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TableManager<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {

	typealias TableManagerConfigure = (Cell, Item, Int) -> Void
	typealias TableManagerSelect = (Item, Int) -> Void
	
	var items: [Item]
	
	var configure: TableManagerConfigure!
	var select: TableManagerSelect?
	
	init(table: UITableView, items someItems: [Item]) {
		
		items = someItems
		
		super.init()
		
		table.register(cellNib, forCellReuseIdentifier: cellReuseIdentifier)

		table.dataSource = self
		table.delegate = self
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
}
