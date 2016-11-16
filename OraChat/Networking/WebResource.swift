//
//  WebResource.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


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
