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
	var tableManager: TextFieldTableManager<AuthenticationInfo>?
	
	override func viewDidLoad() {
	
		super.viewDidLoad()

		guard let tableView = tableView else {exit(1)}

		weak var weakSelf = self
		tableManager = TextFieldTableManager(table: tableView, item: info) {
			
			(newInfo: AuthenticationInfo) in
			
			guard let strongSelf = weakSelf else {return}
			strongSelf.info = newInfo
		}
	}
	
	@IBAction func onLogin() {
	
		weak var weakSelf = self
		webservice.load(info.login) {
			
			(token: AuthorizationToken?, error: Error?) in
			
			guard let strongSelf = weakSelf else {return}
			
			if let token = token {

				strongSelf.webservice.authorizationToken = token
				strongSelf.dismiss(animated: true, completion: nil)
			}
			else {
				
				strongSelf.showCredentialsError()
			}
		}
	}
	
	private func showCredentialsError() {
		
		let alertTitle = NSLocalizedString("Error", comment: "Authorization")
		let alertMessage = NSLocalizedString("Invalid credentials", comment: "Authorization")
		let buttonTitle = NSLocalizedString("OK", comment: "OK")
		
		let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
		let dismiss = UIAlertAction(title: buttonTitle, style: .default) { _ in
			alert.dismiss(animated: true, completion: nil)
		}
		alert.addAction(dismiss)
		
		self.present(alert, animated: true, completion: nil)
	}
}
