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
	// Instances of Item will be saved to a single file in the Documents directory
	// Construct an URL to this file -->
	let itemArchiveURL: NSURL = {
		let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		let documentsDirectory = documentsDirectories.first!
		return documentsDirectory.URLByAppendingPathComponent("items.archive")
	}()
	
	init() {
		// NSKeyedUnarchiver will inspect the type of the root object and create and instance of that type
		if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
			allItems += archivedItems
		}
	}
	
	func createItem() -> Item {
		let newItem = Item(random: true)
		allItems.append(newItem)
		return newItem
	}
	
	func removeItem(item: Item) {
		if let index = allItems.indexOf(item){
			allItems.removeAtIndex(index)
		}
	}
	
	func moveItemAtIndex(fromIndex: Int, toIndex: Int){
		if fromIndex == toIndex {
			return
		}
		
		// Get reference to object being moved so you can reinsert it
		let movedItem = allItems[fromIndex]
		
		// Remove item from array
		allItems.removeAtIndex(fromIndex)
		
		// Insert item in array at new location
		allItems.insert(movedItem, atIndex: toIndex)
	}
	
	func saveChanges() -> Bool {
		print("Saving items to: \(itemArchiveURL.path!)")
		return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
		// All instance of Items are encoded with the same NSKeyedArchiver
		// The allItems array calls encodeWithCoder to all of the objects it contains
	}
	
	
	
	
	// Designated initializer: add five random items
//	init() {
//		for _ in 0..<5 {
//			createItem()
//		}
//	}
	// Commented out with the recent addition of the Add button that generates a random item
	// and adds it to both the store (model) and the tableview (view)
	
	
	
}
