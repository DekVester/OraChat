//
//  HTTPMethod.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/16/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


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
