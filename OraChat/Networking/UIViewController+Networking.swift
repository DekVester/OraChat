//
//  UIViewController+Networking.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
	
	@discardableResult func handle(error: Error) -> Bool {

		/*
		Basic network errors handling logic - to be enhanced...
		*/
		var handled = false
		
		let nserror = error as NSError
		if nserror.code == NSURLErrorUserAuthenticationRequired {
		
			showAuthentication()
			handled = true
		}
		
		return handled
	}
	
	func showAuthentication() {
		
		let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
		let authenticationViewController = storyboard.instantiateInitialViewController()!
		show(authenticationViewController, sender: nil)
	}
	
	var webservice: Webservice {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.webservice
	}
}
