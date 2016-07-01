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
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemStore.allItems.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		// Create an instance of UITableViewCell with default appearance
		let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
		// dequeue... will check the pool to see wether a cell withthe correct reuse identifier already exists.
		// If so it will dequeue this cell. If not, a new cell will be created an returned.
		
		// Set the text on the cell with the description of the item that is at the nth index of items,
		// where n = row this cell will appear in on the tableview
		let item = itemStore.allItems[indexPath.row]
		
		cell.textLabel?.text = item.name
		cell.detailTextLabel?.text = "$\(item.valueInDollars)"
		
		return cell
	}
	
}
