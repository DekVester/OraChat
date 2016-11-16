//
//  URLRequest+WebResource.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


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
