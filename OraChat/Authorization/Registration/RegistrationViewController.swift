//
//  RegistrationViewController.swift
//  OraMessenger
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class RegistrationViewController: UITableViewController {

	var info = AccountInfo()
	var tableManager: TextFieldTableManager<AccountInfo>?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		guard let tableView = tableView else {exit(1)}
		
		weak var weakSelf = self
		tableManager = TextFieldTableManager(table: tableView, item: info) {
			
			(newInfo: AccountInfo) in
			
			guard let strongSelf = weakSelf else {return}
			strongSelf.info = newInfo
		}
	}
}
