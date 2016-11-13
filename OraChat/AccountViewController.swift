//
//  AccountViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
	
	var info = AccountInfo() {
		didSet {
			if let tableManager = tableManager {
				tableManager.item = info
			}
		}
	}
	
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		weak var weakSelf = self
		webservice.load(AccountInfo.me) {
			(result: AccountInfo?, error: Error?) in
			
			guard let strongSelf = weakSelf else {return}
			
			if let newInfo = result {
				strongSelf.info = newInfo
			}
			else {
				strongSelf.handle(error: error!)
			}
		}
	}
	
	private var tableManager: TextFieldTableManager<AccountInfo>?
}
