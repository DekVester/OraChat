//
//  CreateMessageViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/15/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

//Probably, to be implemented, when the corresponding UI reqs are introduced
//class CreateMessageViewController: UIViewController {
//}

class CreateMessageTempHelper {
	
	class func controller(completion: @escaping (Message)->Void) -> UIAlertController {
		
		let alert = UIAlertController(title: "Create Message", message: "Enter new message text", preferredStyle: .alert)
		alert.addTextField()
		
		let done = UIAlertAction(title: "Done", style: .default) {
			_ in
			
			let creatingMessageText = alert.textFields?.first?.text ?? ""
			let creatingMessage = Message(text: creatingMessageText)
			completion(creatingMessage)
		}
		alert.addAction(done)
		
		return alert
	}
}
