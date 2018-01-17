//
//  ItemStore.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/11.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation
import CoreLocation

class ItemStore {
    
    var allItems : [[Item]] = [[],[]]
    let itemsArchiveURL: NSURL = {
       let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
 
    func saveChanges() -> Bool {
        print("Saving all items to : \(itemsArchiveURL.path)")
        
        /// recursively, on each item, encodeWithCoder is called here to ARCHIVE
        return NSKeyedArchiver.archiveRootObject(allItems[0], toFile: itemsArchiveURL.path!)
    }
    
    
    init(demo: Bool) {
        if demo {
            createItemDemo()
        }
        else{
            if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemsArchiveURL.path!) as? [Item] {
                allItems[0] += archivedItems
            }
        }
        
    }
    
    
    // add...
    func createItem(location: CLLocation, memo: String, time: NSDate = NSDate()) -> Item {
        let item = Item(locationCreated: location, memoCreated: memo, timeCreated: time )
        allItems[0].insert(item, atIndex: 0)
        
        return item
    }
    
    // add-Demo
    private func createItemDemo()
    {
        
        var day = 0, hour = -1, minute = 15
        var time : NSDate {
                let calendar = NSCalendar.currentCalendar()
                let components = NSDateComponents()
                components.day = {
                    day += 1
                    day %= 30
                    return day}()
                components.month = 04
                components.year = 2017
                components.hour = {
                    hour += 1
                    hour %= 24
                    return hour
                }()
                components.minute = {
                    minute += 1
                    minute %= 60
                    return minute
                }()
                return calendar.dateFromComponents(components)!
        }
        
            let syrGps = CLLocation(latitude: 43.0399088990879, longitude: -76.13250999918435)
            let nycGps = CLLocation(latitude: 40.741895, longitude: -73.989308)
        
        for i in 1..<31 {
            createItem(syrGps, memo: "bus schedule at TIME\(i) checked ", time: time)
        }
        for i in 5..<48 {
            createItem(nycGps, memo: "nice shop found on \(i)th Street", time: time)
        }
//            createItem(syrGps, memo: "bus schedule @4:30pm", time: time)
//            createItem(syrGps, memo:"bus schedule @5:14pm")
//            createItem(syrGps, memo:"bus#31 to SU @8:39am")
//            createItem(nycGps, memo:"call Mike 800-2009090")
//            createItem(nycGps, memo:"find a nice cookie shop @Brooklyn")
    }
    
    // remove...
    func removeItem(indexOfSection: Int, item: Item) {
        if let index = allItems[indexOfSection].indexOf(item) {
            allItems[indexOfSection].removeAtIndex(index)
        }
    }
    
    // reorder...
    func moveItemFromIndex(fromIndex: NSIndexPath, toIndex: NSIndexPath) {
        if fromIndex == toIndex {
            return
        }
        
        let item = allItems[fromIndex.section][fromIndex.row]
        
        allItems[fromIndex.section].removeAtIndex(fromIndex.row)
        
        allItems[toIndex.section].insert(item, atIndex: toIndex.row)
    }
    
}