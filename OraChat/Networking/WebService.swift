//
//  WebService.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation
import UIKit


typealias JSONDictionary = [String: Any]


final class Webservice {
	
	let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
	
	var authorizationToken: String?
	
	@discardableResult func load<A>(_ resource: WebResource<A>, completion: @escaping (A?, Error?) -> Void) -> URLSessionDataTask {

		var request = URLRequest(resource: resource, baseUrl: baseUrl)
		
		/*
		Apply authorization token, if possible
		*/
		if let token = authorizationToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}

		let task = session.dataTask(with: request) {
			
			(data, response, error) in

			/*
			Basic error handling logic - to be enhanced
			*/
			if let error = error {
				completion(nil, error)
				return
			}

			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200 ... 299 ~= statusCode else {
			
				let error = NSError(domain: Webservice.errorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: NSLocalizedString("Network error", comment: "Webservice")])
				completion(nil, error)
				return
			}
			
			guard let result = data.flatMap(resource.parse) else {
				
				let error = NSError(domain: Webservice.errorDomain, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey : NSLocalizedString("Invalid response", comment: "Webservice")])
				completion(nil, error)
				return
			}
			
			completion(result, nil)
		}
		task.resume()
		
		return task
	}
	
	private let baseUrl = URL(string: "https://private-anon-918747f463-oracodechallenge.apiary-mock.com/")!
	
	private static let errorDomain = Bundle.main.bundleIdentifier!
}
