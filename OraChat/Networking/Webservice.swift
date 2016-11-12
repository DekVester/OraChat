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
}

extension HttpMethod {
	var text: String {
		switch self {
		case .get: return "GET"
		case .post: return "POST"
		}
	}
	
	func map<B>(f: (Body) -> B) -> HttpMethod<B> {
		switch self {
		case .get: return .get
		case .post(let body):
			return .post(f(body))
		}
		
	}
}


struct WebResource<A> {
	let url: URL
	let method: HttpMethod<Data>
	let parse: (Data) -> A?
}

extension WebResource {
	init(url: URL, method: HttpMethod<Any> = .get, parseJSON: @escaping (Any) -> A?) {
		self.url = url
		self.method = method.map { json in
			try! JSONSerialization.data(withJSONObject: json, options: [])
		}
		self.parse = { data in
			let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
			return json.flatMap(parseJSON)
		}
	}
}


//func pushNotification(token: String) -> WebResource<Bool> {
//	let url = NSURL(string: "Some test URL")!
//	let dictionary = ["token": token]
//	return WebResource(url: url, method: .post(dictionary), parseJSON: { _ in
//		return true
//	})
//}


extension URLRequest {
	init<A>(resource: WebResource<A>) {
		self.init(url: resource.url)
		httpMethod = resource.method.text
		if case let .post(data) = resource.method {
			httpBody = data
		}
	}
}


final class Webservice {
	
	func load<A>(resource: WebResource<A>, completion: @escaping (A?) -> Void) {
		let request = URLRequest(resource: resource)
		URLSession.shared.dataTask(with: request) { data, _, _ in
			completion(data.flatMap(resource.parse))
			}.resume()
	}
}
