//
//  TextFieldTableManager.swift
//  OraChat
//
//  Created by Igor Vasilev on 11/10/16.
//  Copyright © 2016 Productive Edge. All rights reserved.
//

import UIKit


class TextFieldTableManager<Representable: TextFieldTableRepresentable>: TableManager<TextFieldTableRow, TextFieldTableCell> {

	typealias RepresentableItemChange = (Representable) -> Void
	
	init(table: UITableView, item anItem: Representable, change: @escaping RepresentableItemChange) {

		let rows = anItem.tableRepresentation()
		super.init(table: table, items: rows)
		
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
}
