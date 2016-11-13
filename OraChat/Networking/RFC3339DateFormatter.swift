//
//  RFC3339DateFormatter.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/13/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import Foundation

/**
Date formatte for fixed-format dates (internet dates)
*/
extension DateFormatter {
	
	@nonobjc static var RFC3339: DateFormatter = {
		
		let formatter = DateFormatter()
		
		let enUSPOSIXLocale = Locale(identifier: "en_US_POSIX")
		formatter.locale = enUSPOSIXLocale
		
		formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)!
		
		return formatter
	}()
}
