//
//  TimeViewController.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit

class TimeViewController : UIViewController {
    var itemStore: ItemStore!
    
    var bubbleAnimationHandler : BubbleAnimation!
    
    @IBOutlet var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor).active = true
        toolbar.backgroundColor = UIColor(red: 1, green: 1, blue: 0.6863, alpha: 1.0)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bubbleAnimationHandler.clearBubbleViews()
    }
    
    /// touch and delete a bubble, animition reording
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        let point = touch.locationInView(view)
        
        bubbleAnimationHandler.touchBubbleViewCauseDeletionAnimtion(point, superView: view)
    }
    
    
    @IBAction func hitDaily( button: UIBarButtonItem ) {
        
        toolbar.items?.forEach(){$0.tintColor = UIColor.blueColor()}
        button.tintColor = UIColor.greenColor()
        
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(nil, timeSpan: .Daily, items: itemStore.allItems[0], superView: view, refView: toolbar)
    }
    @IBAction func hitWeekly( button: UIBarButtonItem ) {
        
        toolbar.items?.forEach(){$0.tintColor = UIColor.blueColor()}
        button.tintColor = UIColor.greenColor()
        
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(nil, timeSpan: .Weekly, items: itemStore.allItems[0], superView: view, refView: toolbar)
    }
    @IBAction func hitMonthly( button: UIBarButtonItem ) {
        
        toolbar.items?.forEach(){$0.tintColor = UIColor.blueColor()}
        button.tintColor = UIColor.greenColor()
        
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(nil, timeSpan: .Monthly, items: itemStore.allItems[0], superView: view, refView: toolbar)
    }
}


//@IBAction func chooseDaily(button: UIBarButtonItem) {
//    print (#function)
//    
//    let imagePicker = UIImagePickerController()
//    
//    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
//        imagePicker.sourceType = .Camera
//    } else {
//        imagePicker.sourceType = .PhotoLibrary
//    }
//    
//    imagePicker.delegate = self
//    
//    presentViewController(imagePicker, animated: true, completion: nil)
//}
//
//func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//    print(#function)
//    
//    //        for item in info {
//    //            print( item )
//    //        }
//    
//    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//    imageView.image = image
//    dismissViewControllerAnimated(true, completion: nil)
//}
