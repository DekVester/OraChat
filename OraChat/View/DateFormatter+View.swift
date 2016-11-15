//
//  DateFormatter+View.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/15/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation


/**
Date formatte for dates visualization in UI
*/
extension DateFormatter {
	
	@nonobjc static var visualization: DateFormatter = {
		
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		return formatter
	}()
}
