//
//  BubbleAnimation.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/26.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
import CoreLocation

enum TimeSpan {
    case Daily  // 24 hours difference
    case Weekly  // 7*24hours diff
    case Monthly  // 30*24hours diff
    case None  // 0
}


class BubbleAnimation {
    var bubbleViews =  [UIView]()
    
    
    //// touch which Index?
    func touchBubbleViewCauseDeletionAnimtion( touchPoint : CGPoint, superView:UIView ) {
        
        for i in 0..<bubbleViews.count {
            let v = bubbleViews[i]
            let xDist = v.center.x - touchPoint.x
            let yDist = v.center.y - touchPoint.y
            
            let dis = sqrt((xDist * xDist) + (yDist * yDist))
            if dis <= v.frame.width/2 {
                v.removeFromSuperview()
                
                bubbleViews.removeAtIndex(i)
                popBubbles(superView)
                break
            }
        }

    }
    

    
    
    //// load bubble's UIView onto "mainView", by CLLocation/TimeSpan,  the refView indicate the bottom
    func loadAndAnimationBubbleViewsByRules( location: CLLocation?, timeSpan: TimeSpan, items: [Item], superView: UIView, refView: UIView ) {
        
        var filteredItems = [Item]()  // array is value-copy!
        
        clearBubbleViews()
        
        let nearestMiles = 2.0
        var distanceInMeters: CLLocationDistance!
        
        if let loc = location {
            for item in items {
                distanceInMeters = loc.distanceFromLocation( item.locationCreated )
                
                if let value = distanceInMeters {
                    if value/1609.344 <= nearestMiles {
                        
                        filteredItems.append(item)
                    }
                }
            }
        }
        else { // there is no location rules, all items assign to filteredItems
            filteredItems = items
        }

        
        /// check time cycle rules, based on filterItems
        for item in filteredItems {
            
            let ti = abs(Int(item.dateCreated.timeIntervalSinceNow))
            
            let hours = ti / 3600   // hours difference, if hours%24 = 0 means 24 hours
            let days = hours/24     // days difference, if days%7 = 0, means weekly
            
            let cycleDiffer: Int = {
                var cyc:Int
                switch (timeSpan) {
                case .Daily:
                    cyc = hours%24  // 0 (1 ?) means same hour daily
                case .Weekly:
                    cyc = days%7 // 0 means same weekday
                case .Monthly:
                    cyc = days%30 // 0 (..1 ?) means same day monthly
                case .None:
                    cyc = 0
                }
                return cyc
            }()
            
            if 0 == cycleDiffer {
                bubbleViews.append(BubbleCore(message: item.memoCreated, refView: refView).myView)
            }
            else if (1 == cycleDiffer && ( timeSpan == .Daily || timeSpan == .Monthly )) {
                bubbleViews.append(BubbleCore(message: item.memoCreated, refView: refView).myView)
            }
        }
        
        bubbleViews.forEach(){
            superView.addSubview($0)
        }
        
        popBubbles(superView)
    }
    
    
    
    //// Bubble moving up animation
    private func popBubbles( superView: UIView ) {
        var y = UIApplication.sharedApplication().statusBarFrame.height
        var preY: CGFloat?
        
        let bubbleWidth = bubbleViews.first?.frame.width
        
        if let widithValue = bubbleWidth {
            var x: CGFloat {
                if( preY  == nil ) { // 0- half width
                    return CGFloat(arc4random_uniform(UInt32(superView.frame.width/2.0 - widithValue)))
                } else {  // half width -- width
                    return superView.frame.width/2.0 + CGFloat( arc4random_uniform(UInt32(superView.frame.width/2.0 - widithValue)) )
                }
            }
            
            self.bubbleViews.forEach() { (bubble) in
                UIView.animateWithDuration(2) {
                    bubble.frame.origin.x = {
                        let xval = x
                        let bound = superView.frame.width - bubble.frame.width
                        if xval > bound {
                            return bound
                        }
                        else {
                            return xval
                        }
                    }()
                    
                    if let unwrap = preY {
                        bubble.frame.origin.y = unwrap
                        y += bubble.frame.height+2+CGFloat(arc4random_uniform(6))
                        preY = nil
                    } else {
                        bubble.frame.origin.y = y
                        preY = y
                    }
                    
                    superView.layoutIfNeeded()
                }
                
            }
        }
    }
 
    
    func clearBubbleViews() {
        self.bubbleViews.forEach(){
            $0.removeFromSuperview()
        }
        self.bubbleViews.removeAll()
    }
    
}
