//
//  ItemCell.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/7/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
	
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var serialNumberLabel: UILabel!
	@IBOutlet var valueLabel: UILabel!
	
	var value: Int! {
		willSet{
			if newValue < 50 {
				valueLabel.textColor = UIColor.greenColor()
			} else {
				valueLabel.textColor = UIColor.redColor()
			}
			valueLabel.text = "$\(newValue)"
		}
	}
	
	func updateLabels(){
		let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
		nameLabel.font = bodyFont
		valueLabel.font = bodyFont
		
		let caption1Font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
		serialNumberLabel.font = caption1Font
	}
	
}
