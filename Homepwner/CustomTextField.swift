//
//  CustomTextField.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/14/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
	
	override func becomeFirstResponder() -> Bool {
		super.becomeFirstResponder()
		
		self.borderStyle = .RoundedRect
		self.layer.cornerRadius = 5
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.redColor().CGColor
		return true
	}
	
	override func resignFirstResponder() -> Bool {
		super.resignFirstResponder()
		
		self.borderStyle = .RoundedRect
		self.layer.cornerRadius = 5
		self.layer.borderWidth = 0.5
		self.layer.borderColor = UIColor.clearColor().CGColor
		return true
	}
	
}
