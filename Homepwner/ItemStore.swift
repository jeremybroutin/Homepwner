//
//  ItemStore.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/1/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

// The ItemStore will store the Item instances.
// It will be responsible for performing operations on the array (reordering, adding and removing)
// as well as saving and loading from disk.

// ItemStore is a SWIFT base class: does not inherit from any other class

class ItemStore {
	
	var allItems = [Item]()
	
	func createItem() -> Item {
		let newItem = Item(random: true)
		allItems.append(newItem)
		return newItem
	}
	
	// Designated initializer: add five random items
	init() {
		for _ in 0..<5 {
			createItem()
		}
	}
	
}
