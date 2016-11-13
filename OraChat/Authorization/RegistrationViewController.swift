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
	private var tableListener: TextFieldTableListener<AccountInfo>?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		guard let tableView = tableView else {exit(1)}
		
		weak var weakSelf = self
		tableListener = TextFieldTableListener(item: info, preparingTable: tableView) {
			
			(newInfo: AccountInfo) in
			
			guard let strongSelf = weakSelf else {return}
			strongSelf.info = newInfo
		}
	}
}

//MARK:- Actions

private extension RegistrationViewController {
	
	@IBAction func onRegister() {
		
		weak var weakSelf = self
		webservice.load(info.register) {
			
			(token: AuthorizationToken?, error: Error?) in
			
			guard let strongSelf = weakSelf else {return}
			
			if let token = token {
				
				strongSelf.webservice.authorizationToken = token
				strongSelf.dismiss(animated: true, completion: nil)
			}
			else {
				
				strongSelf.showRegistrationError()
			}
		}
	}
	
	func showRegistrationError() {
		
		let alertTitle = NSLocalizedString("Error", comment: "Authorization")
		let alertMessage = NSLocalizedString("Invalid registration information", comment: "Authorization")
		let buttonTitle = NSLocalizedString("OK", comment: "OK")
		
		let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
		let dismiss = UIAlertAction(title: buttonTitle, style: .default) { _ in
			alert.dismiss(animated: true, completion: nil)
		}
		alert.addAction(dismiss)
		
		self.present(alert, animated: true, completion: nil)
	}
}
