//
//  Webservice.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/12/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation
import UIKit


typealias JSONDictionary = [String: Any]


enum HttpMethod<Body> {
	case get
	case post(Body)
	case put(Body)
}

extension HttpMethod {
	var text: String {
		switch self {
		case .get: return "GET"
		case .post: return "POST"
		case .put: return "PUT"
		}
	}
	
	func map<B>(f: (Body) -> B) -> HttpMethod<B> {
		switch self {
		case .get: return .get
		case .post(let body):
			return .post(f(body))
		case .put(let body):
			return .put(f(body))
		}
	}
}


struct WebResource<A> {
	let urlPath: String
	let method: HttpMethod<Data>
	let parse: (Data) -> A?
}

extension WebResource {
	
	init(path: String, method jsonBodyMethod: HttpMethod<Any> = .get, parseJson: @escaping (Any) -> A?) {
		urlPath = path
		method = jsonBodyMethod.map {
			json in
			try! JSONSerialization.data(withJSONObject: json, options: [])
		}
		parse = {
			data in
			let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
			return json.flatMap(parseJson)
		}
	}
}

extension URLRequest {
	
	init<A>(resource: WebResource<A>, baseUrl: URL) {
		
		let path = baseUrl.absoluteString + resource.urlPath
		let url = URL(string: path)!
//		let url = baseUrl.appendingPathComponent(path)
		self.init(url: url)
		
		/*
		JSON content
		*/
		setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
		setValue("application/json", forHTTPHeaderField: "Accept")
		
		httpMethod = resource.method.text
		
		switch resource.method {
		case let .post(data), let .put(data):
			httpBody = data
		default:
			break
		}
	}
}

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
//		else {
//			request.addValue("", forHTTPHeaderField: "Authorization")
//		}

		let task = session.dataTask(with: request) {
			
			(data, response, error) in

			/*
			Basic error handling logic - to be enhanced
			*/
			if let error = error {
				completion(nil, error)
				return
			}

			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
			
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
	
	private let baseUrl = URL(string: "https://private-d9e5b-oracodechallenge.apiary-mock.com/")!
	
	private static let errorDomain = Bundle.main.bundleIdentifier!
}
