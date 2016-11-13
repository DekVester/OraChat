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
		
		let url = baseUrl.appendingPathComponent(resource.urlPath)
		self.init(url: url)
		
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
	
	func load<A>(_ resource: WebResource<A>, completion: @escaping (A?, Error?) -> Void) {

		var request = URLRequest(resource: resource, baseUrl: baseUrl)
		
		/*
		Apply authorization token, if possible
		*/
		if let token = authorizationToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		let task = session.dataTask(with: request) {
			
			(data, response, error) in

			completion(data.flatMap(resource.parse), error)
		}
		task.resume()
	}
	
	private let baseUrl = URL(string: "http://private-d9e5b-oracodechallenge.apiary-mock.com/")!
}
