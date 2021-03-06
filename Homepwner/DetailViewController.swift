//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/9/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	// MARK: - Properties
	
	// UIImagePickerController's delegate property is actually inherited from its superclass: UINavigationController
	// Its inherited delegate is declared to reference an object that conforms to UINavigationControllerDelegate
	
	@IBOutlet var nameField: CustomTextField!
	@IBOutlet var serialNumberField: CustomTextField!
	@IBOutlet var valueField: CustomTextField!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var clearImageButton: UIBarButtonItem!
	
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
	
	var imageStore: ImageStore!
	
	// MARK: - App Life Cycle
	
	// Set the text on each textfield to the appropriate value from the Item instance
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		nameField.text = item.name
		serialNumberField.text = item.serialNumber
		// valueField.text = "\(item.valueInDollars)" // replace by formatter below
		valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
		// dateLabel.text = "\(item.dateCreated)" // replace by formatter below
		dateLabel.text = dateFormatter.stringFromDate(item.dateCreated)
		
		// Get the item key
		let key = item.itemKey
		
		// If there is an associated with the item, display it on the image view
		if let imageToDisplay = imageStore.imageForKey(key){
			imageView.image = imageToDisplay
			clearImageButton.enabled = true
		} else {
			clearImageButton.enabled = false
		}
		
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
	
	// MARK: - Actions
	
	// Dismiss keyboard on any tap but the keyboard
	@IBAction func backgroundTapped(sender: UITapGestureRecognizer) {
		view.endEditing(true)
		// convenient way to dismiss the keyboard wuthout having to know which text field is the first responder.
	}
	
	@IBAction func takePicture(sender: UIBarButtonItem) {
		let imagePicker = UIImagePickerController()
		// If the device has a camera take a picture; otherwise,
		// just pick from photo library
		if UIImagePickerController.isSourceTypeAvailable(.Camera){
			imagePicker.sourceType = .Camera
			// Gold challenge: add cameraOverlayView
			let cameraOverlayView = UIImageView(image: UIImage(named: "Crosshair"))
			cameraOverlayView.contentMode = .Center
			cameraOverlayView.frame = imagePicker.view.frame
			//cameraOverlayView.frame = imagePicker.cameraOverlayView!.frame
			imagePicker.cameraOverlayView = cameraOverlayView
		} else {
			imagePicker.sourceType = .PhotoLibrary
		}
		// Bronze challenge: allow edition of selected image
		imagePicker.allowsEditing = true
		imagePicker.delegate = self

		// Place image picker on the screen
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	// Silver Challenge: add a button to clear the image for an item
	@IBAction func deletePicture(sender: UIBarButtonItem) {
		// Remove image from ImageView
		imageView.image = nil
		
		// Remove image from cache
		imageStore.deleteImageForKey(item.itemKey)
		
		// Disable clear button
		clearImageButton.enabled = false
	}
	
	
	// When a text field is touched, it automatically becomes the first responder
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		// removing the first responder attribution allows the keyboard dismisal
		textField.resignFirstResponder()
		
		return true
	}
	
	// MARK: - Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowDatePicker" {
			let datePickerViewController = segue.destinationViewController as! DatePickerViewController
			datePickerViewController.item = item
		}
	}
	
	// MARK: - Image Picker
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		// Get picked image from info dictionary
		// let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		// Bronze Challenge: selected the edited image instead
		let image = info[UIImagePickerControllerEditedImage] as! UIImage
		
		// Store the image in the imageStore for the item's key
		imageStore.setImage(image, forKey: item.itemKey)
		
		// Put that image on the screen in the image view and enable clear button
		imageView.image = image
		clearImageButton.enabled = true
		
		// Take image picker off the screen
		dismissViewControllerAnimated(true, completion: nil)
	}
	
}
