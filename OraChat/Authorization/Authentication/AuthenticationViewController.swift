//
//  AuthenticationViewController.swift
//  OraMessenger
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class AuthenticationViewController: UITableViewController {

	var info = AuthenticationInfo()
	var tableManager: AuthenticationTableManager?
	
	override func viewDidLoad() {
	
		super.viewDidLoad()

		guard let tableView = tableView else {exit(1)}

		weak var weakSelf = self
		tableManager = AuthenticationTableManager(table: tableView, info: info, change: {
			
			(newInfo: AuthenticationInfo) in
			
			guard let  strongSelf = weakSelf else {return}
			strongSelf.info = newInfo
		})
	}
}
