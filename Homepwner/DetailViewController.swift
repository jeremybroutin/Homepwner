//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/9/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet var nameField: CustomTextField!
	@IBOutlet var serialNumberField: CustomTextField!
	@IBOutlet var valueField: CustomTextField!
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
	var item: Item! {
		didSet{
			navigationItem.title = item.name // dynamic set nav bar title based on item name
		}
	}
	
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
	
	// Called when VC is about to be popped out of the nav stack
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Clear first responder
		view.endEditing(true)
		
		// Save changes to the item
		item.name = nameField.text ?? ""
		item.serialNumber = serialNumberField.text
		
		if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText) {
			item.valueInDollars = value.integerValue
		} else {
			item.valueInDollars = 0
		}
	}
	
	// Dismiss keyboard on any tap but the keyboard
	@IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
		view.endEditing(true)
		// convenient way to dismiss the keyboard wuthout having to know which text field is the first responder.
	}
	
	// When a text field is touched, it automatically becomes the first responder
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		// removing the first responder attribution allows the keyboard dismisal
		textField.resignFirstResponder()
		
		return true
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDatePicker" {
			let datePickerViewController = segue.destinationViewController as! DatePickerViewController
			datePickerViewController.item = item
		}
	}
	
}
