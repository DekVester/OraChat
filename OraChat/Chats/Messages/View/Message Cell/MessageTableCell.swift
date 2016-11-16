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
	@IBOutlet weak var bubbleConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var footerLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		bubbleView.layer.cornerRadius = 20.0
	}
	
	var bubbleRight = false {
		
		didSet {
			refreshBubbleIndentation()
		}
	}
	
	private func refreshBubbleIndentation() {
		
		footerLabel.textAlignment = bubbleRight ? .right : .left
		
		let constant = bubbleRight ? fabs(bubbleConstraint.constant) : -fabs(bubbleConstraint.constant)
		bubbleConstraint.isActive = false

		let attribute: NSLayoutAttribute = bubbleRight ? .trailing : .leading

		let constraint = NSLayoutConstraint(item: contentView, attribute: attribute, relatedBy: .equal, toItem: bubbleView, attribute: attribute, multiplier: 1.0, constant: constant)
		constraint.isActive = true
		
		bubbleConstraint = constraint
	}
}
