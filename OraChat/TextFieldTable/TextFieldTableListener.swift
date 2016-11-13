//
//  TextFieldTableListener.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TextFieldTableListener<Representable: TextFieldTableRepresentable>: TableListener<TextFieldTableRow, TextFieldTableCell> {

	typealias RepresentableItemChange = (Representable) -> Void
	
	init(item anItem: Representable, preparingTable table: UITableView, change: @escaping RepresentableItemChange) {

		let rows = anItem.tableRepresentation()
		super.init(items: rows, preparingTable: table)
		
		weak var weakSelf = self
		
		configure = {
			
			(cell: TextFieldTableCell, row: TextFieldTableRow, index: Int) in
			
			cell.label.text = row.title
			cell.field.text = row.value
			cell.field.isSecureTextEntry = row.secure
			
			cell.change = {
				
				(newValue: String) in
				
				guard let strongSelf = weakSelf else {return}
				
				let newRow = row.replaceValue(newValue: newValue)
				strongSelf.items[index] = newRow

				let newRepresentable = Representable(tableRepresentation: strongSelf.items)
				change(newRepresentable)
			}
		}
	}
	
	var item: Representable {
		
		get {
			return Representable(tableRepresentation: items)
		}
		set(newItem) {
			items = newItem.tableRepresentation()
		}
	}
}
