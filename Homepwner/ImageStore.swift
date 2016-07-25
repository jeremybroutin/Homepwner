//
//  ImageStore.swift
//  Homepwner
//
//  Created by Jeremy Broutin on 7/15/16.
//  Copyright © 2016 Jeremy Broutin. All rights reserved.
//

import UIKit

class ImageStore {
	
	let cache = NSCache()
	
	func setImage(image: UIImage, forKey key: String){
		cache.setObject(image, forKey: key)
		
		// Create full URL for image
		let imageURL = imageURLForKey(key)
		
		// Turn image into JPEG data
//		if let data = UIImageJPEGRepresentation(image, 0.5) {
//			// Write it to full URL
//			data.writeToURL(imageURL, atomically: true)
//		}
		
		// Bronze challenge: save image as PNG instead of JPEG
		if let data = UIImagePNGRepresentation(image){
			data.writeToURL(imageURL, atomically: true)
		}
	}
	
	func imageForKey(key: String) -> UIImage? {
		// return cache.objectForKey(key) as? UIImage
		
		// If we have an image in the cache, return it
		if let existingImage = cache.objectForKey(key) as? UIImage {
			print("Image is loaded from image store / cache")
			return existingImage
		}
		
		// Otherwise, check for a filesystem image and set the cache
		let imageURL = imageURLForKey(key)
		guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else { return nil }
		print("Image is loaded from filesystem")
		cache.setObject(imageFromDisk, forKey: key)
		return imageFromDisk
	}
	
	func deleteImageForKey(key: String) {
		// Remove it from the store
		cache.removeObjectForKey(key)
		
		// And also from the filesystem
		let imageURL = imageURLForKey(key)
		do {
			try NSFileManager.defaultManager().removeItemAtURL(imageURL)
		} catch {
			// The implicit error is passed to the catch block if the method does throw an error
			print("Error removing the image from disk: \(error)")
		}
		// Can use an explicit name instead
		// catch let deleteError {
		//		print("Error is: \(deleteError)")
	}
	
	func imageURLForKey(key:String) -> NSURL {
		let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		let documentDirectory = documentsDirectories.first!
		return documentDirectory.URLByAppendingPathComponent(key)
	}
	
}
