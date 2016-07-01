//
//  Item.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/1/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class Item: NSObject {
	var name: String
	var valueInDollars: Int
	var serialNumber: String?
	let dateCreated: NSDate
	
	// Designated initializer:
	// ensures that all properties in the class have a value
	// and then calls a designated initializer on its superclass (if it has one).
	
	init(name: String, valueInDollars: Int, serialNumber: String?){
		self.name = name
		self.valueInDollars = valueInDollars
		self.serialNumber = serialNumber
		self.dateCreated = NSDate()
		
		super.init()
	}
	
	// Convenience initializer:
	// always calls another initializer on the same class.
	// It must call another initializer on the same type 
	// (vs designated calls another designated initializer on its super class).
	
	convenience init(random: Bool = false) {
		if random {
			let adjectives = ["Fluffy", "Rusty", "Shiny"]
			let nouns = ["Bear", "Spork", "Mac"]
			
			var idx = arc4random_uniform(UInt32(adjectives.count))
			let randomAdjective = adjectives[Int(idx)]
			
			idx = arc4random_uniform(UInt32(nouns.count))
			let randomNoun = nouns[Int(idx)]
			
			let randomName = "\(randomAdjective) \(randomNoun)"
			let randomValue = Int(arc4random_uniform(100))
			let randomSerialNumber = NSUUID().UUIDString.componentsSeparatedByString("-").first!
			
			self.init(name: randomName, valueInDollars: randomValue, serialNumber: randomSerialNumber)
		}
		else {
			self.init(name: "", valueInDollars: 0, serialNumber: nil)
		}
	}
}
