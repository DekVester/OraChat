//
//  CollectionRequestable.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


protocol CollectionRequestable: JSONSerializable {
	
	static var listUrlPath: String {get}
}
