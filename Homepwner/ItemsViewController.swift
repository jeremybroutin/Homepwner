//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/1/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
	
	var itemStore: ItemStore!
	// The itemStore is set externally (in AppDelegate) as per the "dependency inversion principle".
	// To implement the DIP, we use dependency injection, where the lower-level object (the store)
	// is passed to the higher-level oject (ItemsVC) through a property.
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Get the height of the status bar
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
		tableView.contentInset = insets
		tableView.scrollIndicatorInsets = insets
		
		tableView.rowHeight = UITableViewAutomaticDimension // default value for rowHeight (not necessary)
		tableView.estimatedRowHeight = 65 // can improve performance (perf cost to be deferred until users start scrolling and the table view starts loading again)
	}
	
	@IBAction func addNewItem(sender:AnyObject){
		// Must first add a new item to the ItemStore to make sure that the datasource and the UITableView
		// agree on the number of row
		
		// Create a new item and add it to the store
		let newItem = itemStore.createItem()
		
		// Figure out where that item is in the array
		if let index = itemStore.allItems.indexOf(newItem) {
			let indexPath = NSIndexPath(forRow: index, inSection: 0)
			
			// Insert this new row into the table
			tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
	
	@IBAction func toggleEditingMode(sender:AnyObject){
		// If currently in editing mode...
		if editing{
			// Change text of button to inform user of state
			sender.setTitle("Edit", forState: .Normal)
			// Turn off editing mode
			setEditing(false, animated: true)
		} else {
			sender.setTitle("Done", forState: .Normal)
			setEditing(true, animated: true)
		}
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return itemStore.allItems.count
		} else {
			return 1
		}
		
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if indexPath.section == 0 {
			// Create an instance of UITableViewCell with default appearance
			let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
			// dequeue... will check the pool to see wether a cell with the correct reuse identifier already exists.
			// If so it will dequeue this cell. If not, a new cell will be created an returned.
			
			// Set the text on the cell with the description of the item that is at the nth index of items,
			// where n = row this cell will appear in on the tableview
			let item = itemStore.allItems[indexPath.row]
			
			cell.nameLabel.text = item.name
			cell.serialNumberLabel.text = item.serialNumber
			cell.valueLabel.text = "$\(item.valueInDollars)"
			
			return cell
		}
		else {
			let cell = tableView.dequeueReusableCellWithIdentifier("UniqueCell", forIndexPath: indexPath)
			cell.textLabel?.text = "No more items!"
			cell.textLabel?.font = UIFont.boldSystemFontOfSize(17)
			cell.textLabel?.textAlignment = .Center
			return cell
		}
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			let item = itemStore.allItems[indexPath.row]
			
			let title = "Delete \(item.name)?"
			let message = "Are you sure you want to delete this item?"
			let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
			ac.addAction(cancelAction)
			
			let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) in
				
				// Remove the item from the store
				self.itemStore.removeItem(item)
				
				// Also remove that row from the table view with an animation
				self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			})
			ac.addAction(deleteAction)
			
			// Present the Alert Controller modally
			presentViewController(ac, animated: true, completion: nil)
			
			
		}
	}
	
	override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		if destinationIndexPath.section == 0 {
			// Update the model
			itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
		}
		
		// No confirmation required: the table view moves the row on its own authority and reports the move
		// to the its datasource by calling this method.
	}
	
	// Bronze Challenge: change the Delete label to Remove in the cells
	override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
		return "Remove"
	}
	
	// Silver challenge: prevent fixed row to be moved
	override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if indexPath.section == 0 {
			return true
		} else {
			return false
		}
	}
	
	// Gold Challenge: 2 next delegate methods
	// Prevent fixed row to be deleted
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		if indexPath.section == 0 {
			return true
		} else {
			return false
		}
	}
	
	// Prevent items cell to be moved below fixed cell (which is in its own section)
	override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
		if sourceIndexPath.section != proposedDestinationIndexPath.section {
			return sourceIndexPath
		} else {
			return proposedDestinationIndexPath
		}
	}
	
}
