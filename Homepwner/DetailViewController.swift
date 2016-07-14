//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/9/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet var nameField: UITextField!
	@IBOutlet var serialNumberField: UITextField!
	@IBOutlet var valueField: UITextField!
	@IBOutlet var dateLabel: UILabel!
	
	let numberFormatter: NSNumberFormatter = {
		let formatter = NSNumberFormatter()
		formatter.numberStyle = .DecimalStyle
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}()
	
	let dateFormatter: NSDateFormatter = {
		let formatter = NSDateFormatter()
		formatter.dateStyle = .MediumStyle
		formatter.timeStyle = .NoStyle
		return formatter
	}()
	
	// Hold a reference to the Item that is being displayed
	var item: Item!
	
	// Set the text on each textfield to the appropriate value from the Item instance
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		nameField.text = item.name
		serialNumberField.text = item.serialNumber
		// valueField.text = "\(item.valueInDollars)" // replace by formatter below
		valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
		// dateLabel.text = "\(item.dateCreated)" // replace by formatter below
		dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
	}
	
	// "Save" changes to the item when VC is about to be popped out of the nav stack
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		item.name = nameField.text ?? ""
		item.serialNumber = serialNumberField.text
		
		if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
			item.valueInDollars = value.integerValue
		} else {
			item.valueInDollars = 0
		}
	}
}
