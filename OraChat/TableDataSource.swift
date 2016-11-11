//
//  TableDataSource.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TableDataSource<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource {

	typealias TableDataSourceConfigure = ((Cell, Item) -> Void)
	
	let items: [Item]
	let configure: TableDataSourceConfigure
	
	init(items someItems: [Item], configure aConfigure: @escaping TableDataSourceConfigure) {
		
		items = someItems
		configure = aConfigure
		
		super.init()
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
		let item = items[indexPath.row]
		configure(cell, item)
		return cell
	}
}
