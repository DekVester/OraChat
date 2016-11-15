//
//  MessageTableCell.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/11/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

	@IBOutlet weak var bubbleView: UIView!
	
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var footerLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		bubbleView.layer.cornerRadius = 20.0
	}
}
