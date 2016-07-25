//
//  Item.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/1/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
	
	// MARK: - Properties
	
	var name: String
	var valueInDollars: Int
	var serialNumber: String?
	var dateCreated: NSDate
	
	// When a VC wants an image from the store, it will ask the item for the key and search the cache for the image
	var itemKey: String
	
	// MARK: - Initializers
	
	// Designated initializer:
	// ensures that all properties in the class have a value
	// and then calls a designated initializer on its superclass (if it has one).
	
	init(name: String, valueInDollars: Int, serialNumber: String?){
		self.name = name
		self.valueInDollars = valueInDollars
		self.serialNumber = serialNumber
		self.dateCreated = NSDate()
		self.itemKey = NSUUID().UUIDString // Universally unique identifiers
		
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
	
	// MARK: - NSCoding protocol
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: "name")
		aCoder.encodeObject(dateCreated, forKey: "dateCreated")
		aCoder.encodeObject(itemKey, forKey: "itemKey")
		aCoder.encodeObject(serialNumber, forKey: "serialNumber")
		
		aCoder.encodeInteger(valueInDollars, forKey: "valueInDollars")
	}
	
	required init(coder aDecoder: NSCoder){
		name = aDecoder.decodeObjectForKey("name") as! String
		dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
		itemKey = aDecoder.decodeObjectForKey("itemKey") as! String
		serialNumber = aDecoder.decodeObjectForKey("serialNumber") as! String?
		
		valueInDollars = aDecoder.decodeIntegerForKey("valueInDollars")
		
		super.init()
	}
}
