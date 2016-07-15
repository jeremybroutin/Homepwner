//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/15/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
	
	var item: Item! {
		didSet{
			navigationItem.title = item.name
		}
	}
	var backButton: UIBarButtonItem!
	var saveButton: UIBarButtonItem!
	
	@IBOutlet var instructionLabel: UILabel!
	@IBOutlet var datePicker: UIDatePicker!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Add custom Back button to display alert when necessary
		// However we lose the default back button style
		backButton = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(DatePickerViewController.goBack))
		navigationItem.leftBarButtonItem = backButton
		
		saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(DatePickerViewController.saveDate))
		navigationItem.rightBarButtonItem = saveButton
		
		// Insert instruction text and accessible font
		instructionLabel.text = "Edit \(item.name) date"
		instructionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		
		//load the date picker with item date info and limit its max to today's date
		datePicker.date = item.dateCreated
		datePicker.maximumDate = NSDate()

	}
	
	func saveDate(){
		item.dateCreated = datePicker.date
		navigationController?.popViewControllerAnimated(true)
		//dismissViewController is used to close VC presented modally (not pushed)
		//dismissViewControllerAnimated(true, completion: nil)
	}
	
	func goBack(){
		
		// present an alert if there is unsaved changes
		if datePicker.date != item.dateCreated {
			let alertVC = UIAlertController(title: "You have unsaved changes", message: "Are you sure you want to continue?", preferredStyle: .Alert)
			let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
			let continueAction = UIAlertAction(title: "Continue", style: .Destructive, handler: { (_) in
				self.navigationController?.popViewControllerAnimated(true)
			})
			alertVC.addAction(cancelAction)
			alertVC.addAction(continueAction)
			presentViewController(alertVC, animated: true, completion: nil)
		}
		// otherwise dismiss VC directly
		else {
			navigationController?.popViewControllerAnimated(true)
		}
	}
	
}
