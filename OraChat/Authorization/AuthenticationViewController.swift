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
	
	override func viewDidLoad() {
	
		super.viewDidLoad()

		tableListener = TextFieldTableListener(item: info, preparingTable: tableView) {

			[weak self]
			(newInfo: AuthenticationInfo) in
			
			guard let strongSelf = self else {return}
			strongSelf.info = newInfo
		}
	}
	
	private var tableListener: TextFieldTableListener<AuthenticationInfo>!
}

//MARK:- Actions

private extension AuthenticationViewController {
	
	@IBAction func onLogin() {

		webservice.load(info.login) {
			
			[weak self]
			(token: AuthorizationToken?, error: Error?) in
			
			guard let strongSelf = self else {return}
			
			if let token = token {
				
				strongSelf.webservice.authorizationToken = token
				strongSelf.dismiss(animated: true, completion: nil)
			}
			else {
				
				strongSelf.showCredentialsError()
			}
		}
	}
	
	func showCredentialsError() {
		
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
