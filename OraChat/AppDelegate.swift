//
//  AppDelegate.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var webservice = Webservice()//in future make this user-specific

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {		
		return true
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		
		if webservice.authorizationToken == nil {
			window?.rootViewController?.showAuthentication()
		}
	}
}
