//
//  Bubble.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/16.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit

class BubbleCore {
    let myView: UILabel
    var diameter: CGFloat
    
    
    let colors : [UIColor] = [
        /// light
        UIColor(red: 1, green: 0.9216, blue: 0.6078, alpha: 1.0),
        UIColor(red: 0.949, green: 0.698, blue: 1, alpha: 1.0),
        UIColor(red: 0.8, green: 0.8588, blue: 1, alpha: 1.0),
        UIColor(red: 0.8667, green: 1, blue: 0.6392, alpha: 1.0),
        UIColor(red: 1, green: 0.7569, blue: 0.7569, alpha: 1.0),
        UIColor(red: 0.8118, green: 0.9686, blue: 0.851, alpha: 1.0),
        UIColor(red: 0.8392, green: 0.9882, blue: 1, alpha: 1.0),
        UIColor(red: 0.7686, green: 0.6353, blue: 0.6353, alpha: 1.0),
        /// dark
        UIColor(red: 0.0275, green: 0, blue: 0.6, alpha: 1.0),
        UIColor(red: 0.3647, green: 0, blue: 0.4667, alpha: 1.0),
        UIColor(red: 0.4392, green: 0, blue: 0.1529, alpha: 1.0),
        UIColor(red: 0.3294, green: 0.2078, blue: 0, alpha: 1.0),
        UIColor(red: 0.1529, green: 0.2863, blue: 0, alpha: 1.0),
        UIColor(red: 0, green: 0.2196, blue: 0.3882, alpha: 1.0),
        UIColor(red: 0, green: 0.0588, blue: 0.7098, alpha: 1.0),
        UIColor(red: 0.1647, green: 0.5569, blue: 0, alpha: 1.0)
        ]
   
    
    init( message: String, refView: UIView ) {
        
        let refFrame: CGRect = refView.frame
        self.diameter  = refFrame.width*2.8/10.0
        let myFrame = CGRect(x: refFrame.midX-diameter/2, y: refFrame.origin.y, width: diameter, height: diameter)
        myView = UILabel(frame: myFrame)
        myView.layer.zPosition = refView.layer.zPosition - CGFloat(1)
        myView.text = message
        myView.numberOfLines = 4
        myView.minimumScaleFactor = 0.5
        myView.adjustsFontSizeToFitWidth = true
        myView.textAlignment = .Center
        
        myView.textColor = UIColor.whiteColor()
        myView.backgroundColor = {
            let idx = Int(arc4random_uniform(UInt32(colors.count)))
            if idx < colors.count/2 {
                myView.textColor = UIColor.blackColor()
            }
            return colors[Int(idx)]
        }()
        
        myView.layer.cornerRadius = myFrame.width/2
        myView.clipsToBounds = true
    }
    
}

