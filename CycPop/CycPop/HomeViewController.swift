//
//  ViewController.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var memoField: UITextField!
    
    var locationMgr = CLLocationManager()
    
    // instantiated in AppDelegate
    var itemStore: ItemStore!
    
    var bubbleAnimationHandler: BubbleAnimation!
    
    // to update itemsController, pass by AppDelegate
    var itemsViewController : ItemsViewController!
    
    var memoBottomAnchor: NSLayoutConstraint?
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memoField.delegate = self
        
        self.locationMgr.delegate = self
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.requestWhenInUseAuthorization()
        
        /// call Delegate "locationManager" periodically
        //self.locationMgr.startUpdatingLocation()
        self.locationMgr.requestLocation()
        
        setupInputAnchors()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    /// animation to pop up bubbles
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(locationMgr.location, timeSpan: .Daily, items: itemStore.allItems[0], superView: view, refView: memoField)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        bubbleAnimationHandler.clearBubbleViews()
        
    }
    
    
    ///========================================
    
    
    /// anchor memoTextField
    func setupInputAnchors() {
        memoBottomAnchor = memoField.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        
        memoBottomAnchor?.active = true
    }
    
    func handleKeyboardWillShow( notification: NSNotification) {
        //print(notification.userInfo)
        if let height = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height {
            memoBottomAnchor?.constant = -height + bottomLayoutGuide.length
            
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
            
            UIView.animateWithDuration(duration!){
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func handleKeyboardWillHide( notification: NSNotification ) {
        memoBottomAnchor?.constant = 0
        
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        UIView.animateWithDuration(duration!){
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - location Delegate Methods, called in viewDidLoad. But this no use since auto get location if use locationMgr.requestLocation()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    // Mark: -location Delegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: in HomeViewController-\(#function) " + error.localizedDescription)
    }
    
    //// return key event
    /// keybord disappear, and before which, store input memo to itemStore
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let memo = memoField.text, let loc = locationMgr.location {
            itemStore.createItem( loc , memo: memo)
        }
        
        // insert a new item into itemsViewController
        itemsViewController.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
        
        /// run bubble animaiton over again
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(locationMgr.location, timeSpan: .Daily, items: itemStore.allItems[0], superView: view, refView: memoField)
        
        memoField.placeholder = textField.text ?? "add new message"

        memoField.text = nil
        
        return true
    }
    

    //  TapGesture Recognizer on UI
    @IBAction func tappedBackground(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        
        // delete  a touch bubble
        
        let point = gestureRecognizer.locationInView(view)
        bubbleAnimationHandler.touchBubbleViewCauseDeletionAnimtion(point, superView: view)
    }


    
}

