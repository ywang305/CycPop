//
//  Item.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
import CoreLocation

class Item: NSObject, NSCoding {
    
    var memoCreated: String
    var locationCreated: CLLocation
    var dateCreated : NSDate
    
    // designated initializer
    init(locationCreated location: CLLocation, memoCreated memo: String, timeCreated time: NSDate) {

        self.memoCreated = memo
        self.dateCreated = time
        self.locationCreated = location

        super.init()
    }
    
    // archiving in NSCoding Protocol
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(memoCreated, forKey: "memoCreated")
        
        aCoder.encodeObject(dateCreated, forKey: "dateCreated")
        
        //aCoder.encodeObject(locationCreated, forKey: "locationCreated")
        
        aCoder.encodeDouble(locationCreated.coordinate.latitude, forKey: "latitude")
        aCoder.encodeDouble(locationCreated.coordinate.longitude, forKey: "longitude")
    }
    
    required init(coder aDecoder: NSCoder) {
        memoCreated = aDecoder.decodeObjectForKey("memoCreated") as! String
        
        dateCreated = aDecoder.decodeObjectForKey("dateCreated") as! NSDate
        
        //locationCreated = aDecoder.decodeObjectForKey("locationCreated") as! CLLocation
        
        locationCreated = CLLocation(latitude: aDecoder.decodeDoubleForKey("latitude"), longitude: aDecoder.decodeDoubleForKey("longitude"))
        
        super.init()
    }
    
}
