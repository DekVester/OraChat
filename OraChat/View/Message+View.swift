//
//  Message+View.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/15/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


extension Message {
	
	var userDateText: String {
		
		guard let author = author else {return ""}
		var result = author
		
		if let date = creationDate {
			
			result += " - " + DateFormatter.visualization.string(from: date)
		}
		
		return result
	}
}
