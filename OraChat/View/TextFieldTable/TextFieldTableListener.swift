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
		super.init(itemSections: [rows], preparingTable: table)

		configure = {

			[weak self]
			(cell: TextFieldTableCell, row: TextFieldTableRow, indexPath: IndexPath) in
			guard let _ = self else {return}
			
			cell.label.text = row.title
			cell.field.text = row.value
			cell.field.isSecureTextEntry = row.secure
			
			cell.change = {
				
				[weak self]
				(newValue: String) in
				guard let strongSelf = self else {return}
				
				let newRow = row.replaceValue(newValue: newValue)
				strongSelf.itemSections[0][indexPath.row] = newRow

				let newRepresentable = Representable(tableRepresentation: strongSelf.itemSections[0])
				change(newRepresentable)
			}
		}
	}
	
	var item: Representable {
		
		get {
			return Representable(tableRepresentation: itemSections[0])
		}
		set(newItem) {
			itemSections[0] = newItem.tableRepresentation()
		}
	}
}
