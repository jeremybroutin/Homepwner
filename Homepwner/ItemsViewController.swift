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
	
	let sectionTitles = ["Below $50", "Equal and Above $50"]
	var bidimensionalArray = [[Item]]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Get the height of the status bar
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
		let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
		tableView.contentInset = insets
		tableView.scrollIndicatorInsets = insets
		
		splitItemsArray(itemStore.allItems)
		
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		let backgroundImage = UIImage(named: "tableviewBackground")
		let imageView = UIImageView(image: backgroundImage)
		imageView.contentMode = .ScaleAspectFill
		//imageView.alpha = 0.5
		tableView.backgroundView = imageView
		
		tableView.tableFooterView = UIView(frame: CGRectZero)
	}
	
	// Bronze challenge: display two sections
	// One for items >$50 and one for the rest
	
	// Silver Challenge: add a static cell at the bottom of dynamic cell
	// to display "No more" label
	
	// Gold Challenge
	//
	
	// 1 - Split and re join array in two dimensional array
	
	func splitItemsArray(arr: [Item]) -> [[Item]]{
		var below50Array = [Item]()
		var above50Array = [Item]()
		
		for el in arr {
			if el.valueInDollars < 50 {
					below50Array.append(el)
			} else if el.valueInDollars >= 50 {
				above50Array.append(el)
			}
		}
		
		bidimensionalArray.append(below50Array)
		bidimensionalArray.append(above50Array)
		
		return bidimensionalArray
	}
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return sectionTitles.count + 1 // adding last section & row "No more"
	}
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section < sectionTitles.count {
			return sectionTitles[section]
		} else {
			return nil
		}
	}
	
	// 2 - Use the newly populated bidimensional array to count rows in section
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section < sectionTitles.count {
			return bidimensionalArray[section].count
		} else {
			return 1
		}
		
	}
	
	// 3 - Use the newly populated bidimensional array to define the item based on both section and row indexes
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		// dequeue... will check the pool to see wether a cell withthe correct reuse identifier already exists.
		// If so it will dequeue this cell. If not, a new cell will be created an returned.
		
		if indexPath.section < sectionTitles.count {
			let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
			
			// Set the text on the cell with the description of the item that is at the nth index of items,
			// where n = row this cell will appear in on the tableview
			let item = bidimensionalArray[indexPath.section][indexPath.row]
			
			cell.textLabel?.text = item.name
			cell.detailTextLabel?.text = "$\(item.valueInDollars)"
			
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
	
	// Change dynamic row height
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section < sectionTitles.count {
			return 60
		} else {
			return 30 // default is 44
		}
	}
	
	// Make cells transparent
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section < sectionTitles.count {
			cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
			cell.textLabel?.backgroundColor = .clearColor()
			cell.detailTextLabel?.backgroundColor = .clearColor()
		} else {
			cell.textLabel?.textColor = UIColor.darkGrayColor()
		}
	}
	
}
