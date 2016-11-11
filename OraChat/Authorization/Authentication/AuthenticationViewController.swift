//
//  AuthenticationViewController.swift
//  OraMessenger
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class AuthenticationViewController: UITableViewController {
	
	lazy var tableDataSource = AuthenticationDataSource(items: ["Email", "Password"]) {
		(cell: TextFieldCell, item: String) in
		cell.textLabel?.text = item
	}
	
	override func viewDidLoad() {
	
		super.viewDidLoad()
		
		guard let tableView = tableView else {exit(1)}
		
		tableView.register(tableDataSource.cellNib, forCellReuseIdentifier: tableDataSource.cellReuseIdentifier)
		tableView.dataSource = tableDataSource
	}
}
