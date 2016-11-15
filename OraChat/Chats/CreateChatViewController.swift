//
//  CreateChatViewController.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/15/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

//TO BE IMPLEMENTED:
//class CreateChatViewController: UIViewController {
//}

class CreateChatTempHelper {
	
	class func controller(completion: @escaping (Chat)->Void) -> UIAlertController {
		
		let alert = UIAlertController(title: "Create Chat", message: "Enter new chat name", preferredStyle: .alert)
		alert.addTextField()
		
		let done = UIAlertAction(title: "Done", style: .default) {
			_ in
			
			let creatingChatName = alert.textFields?.first?.text ?? ""
			let creatingChat = Chat(name: creatingChatName)
			completion(creatingChat)
		}
		alert.addAction(done)
		
		return alert
	}
}
