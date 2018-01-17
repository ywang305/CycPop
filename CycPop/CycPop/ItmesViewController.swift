//
//  TableViewController.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import CoreLocation
import UIKit

class ItemsViewController : UITableViewController {
    
    // instantiated in AppDelegate
    var itemStore: ItemStore!
    
    let dateFormatter: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "E, d MMM yyy HH:mm:ss"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set contentInset for tableView
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height

        tableView.contentInset = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        // hight dynamicaly computed by sub's height
        tableView.estimatedRowHeight = 65
        
        
        // insert to last as "No more items"
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Automatic)
    }
    

    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Delete"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.section][indexPath.row]
            itemStore.removeItem(indexPath.section, item: item)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // ask datasource to verify that given row is editable
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        else {
            return sourceIndexPath
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ( section == 0) {
            return itemStore.allItems[section].count
        }
        else {
            return 1
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemStore.allItems.count
    }
    
    //Ask data source to insert cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
            cell.memoLabel.text = "No More Items"
            cell.timeLabel.text=nil
            cell.locationLabel.text=nil
            cell.updateLabels()
            cell.backgroundColor = UIColor(red: 0.78, green: 0.87, blue: 0.95, alpha: 1.0)
            return cell
        }
        else {
            let item = itemStore.allItems[indexPath.section][indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
            cell.memoLabel.text = item.memoCreated
            cell.timeLabel.text = {
                return self.dateFormatter.stringFromDate(item.dateCreated)
            }()
            
            
            CLGeocoder().reverseGeocodeLocation( item.locationCreated ){
                (myPlaces, myErr) -> Void in
                if let myPlace = myPlaces?.first {
                    if let street = myPlace.subLocality {
                        cell.locationLabel.text = street
                    }
                    if let city = myPlace.locality {
                        if cell.locationLabel.text != nil {
                            cell.locationLabel.text =  cell.locationLabel.text! + ", " + city
                        }
                        else {
                            cell.locationLabel.text = city
                        }
                    }  
                }
            }
            
            //cell.locationLabel.text = "\(item.locationCreated)"
            
            cell.updateLabels()
            return cell
        }
    }
}
