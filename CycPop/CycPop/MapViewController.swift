//
//  MapViewController.swift
//  CycPop
//
//  Created by 布莱德 王 on 2017/4/2.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//
/*
 reference to youtube "Map View - Current Location in Swift - Xcode 7 iOS Tutorial
 */

import UIKit
import MapKit
import CoreLocation


class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var mapView: MKMapView!
    
    let locationMgr = CLLocationManager()
    
    // instantiated in AppDelegate
    var itemStore: ItemStore!
    
    var bubbleAnimationHandler : BubbleAnimation!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        self.locationMgr.delegate = self
        
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    // MARK: - location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:1, longitudeDelta:1)) // 1 means zoom scalar
            self.mapView.setRegion(region, animated: true)
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: in MapViewController-\(#function) " + error.localizedDescription)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.locationMgr.requestWhenInUseAuthorization()
        
        //self.locationMgr.requestLocation() // call Delegate "locationManager" once and stopUdating
        self.locationMgr.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Animaiton BubbleViews
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(self.locationMgr.location, timeSpan: .None ,items: itemStore.allItems[0], superView: view, refView: mapView)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        bubbleAnimationHandler.clearBubbleViews()
    }
    
    
    // MapView delegate's check mapview range did change
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let newLocation = CLLocation(latitude: latitude, longitude: longitude)
        bubbleAnimationHandler.loadAndAnimationBubbleViewsByRules(newLocation, timeSpan: .None ,items: itemStore.allItems[0], superView: view, refView: mapView)
    }
    
    
    /// touch and delete a bubble, animition reording
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        let point = touch.locationInView(view)
        
        bubbleAnimationHandler.touchBubbleViewCauseDeletionAnimtion(point, superView: view)
    }
}
