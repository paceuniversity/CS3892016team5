//
//  MapViewController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/8/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import MapKit
import Firebase

//CocoaPods-------
import SideMenu
import ExpandingMenu
//---------------

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, EventManagerViewControllerDelegate {
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    
    
    var locationManager = CLLocationManager()
    
    var address: String = ""
    
    var sharedInstance: Singleton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedInstance = Singleton.sharedInstance
        
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    
        
        mapView.showsPointsOfInterest = true
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
        }
        
        createMenu()
        


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let  ref = Firebase(url:"https://mutirao.firebaseio.com/events")
        // Attach a closure to read the data at our posts reference
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let lat = child.childSnapshotForPath("lat")!.value
                let lon = child.childSnapshotForPath("lon")!.value
                let event = Event(id: child.key, lat: lat.doubleValue!, lon: lon.doubleValue!)
                
                dispatch_async(dispatch_get_main_queue(), {
                        self.addPin(event)
                    });
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    // Add any changes here that you want when the map appears
        
        
    }
    
    
    // Implement Expanding menu Cocoapod
    func createMenu(){
        
        let menuButtonSize: CGSize = CGSize(width: 82.0, height: 82.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPointZero, size: menuButtonSize), centerImage: UIImage(named: "chooser-button-tab")!, centerHighlightedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        
        menuButton.center = CGPointMake(self.view.bounds.width - 32.0, self.view.bounds.height - 32.0)
        
        self.view.addSubview(menuButton)
        
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: "icplacewhite")!, highlightedImage: UIImage(named: "icplacewhite")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            //To be completed
            
            
            
            
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: "icaddlocationwhite")!, highlightedImage: UIImage(named: "icaddlocationwhite")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            //To be completed
            self.performSegueWithIdentifier("showEventManager", sender: self)
            
            
        }

        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: nil, image: UIImage(named: "mylocation")!, highlightedImage: UIImage(named: "mylocation")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            
            // Complete

            self.locationManager.startUpdatingLocation()
            
            NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(MapViewController.stopUpdating), userInfo: nil, repeats: false)
            
            
            
            
        }

        
        
        menuButton.addMenuItems([item3, item2, item1])
     //   menuButton.expandingDirection = .Top
        
        menuButton.willPresentMenuItems = { (menu) -> Void in
         //   print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
         //   print("MenuItems dismissed.")
        }
        
      //  item1.titleColor = UIColor.brownColor()
      //  item2.titleColor = UIColor.brownColor()
      //  item3.titleColor = UIColor.brownColor()
        
        
        menuButton.bottomViewColor = UIColor.clearColor()
        menuButton.bottomViewAlpha = 0.2
        menuButton.allowSounds = false
        
       
        
        
        
    }
    
    func stopUpdating(){
        locationManager.stopUpdatingLocation()
    }
    
    
    func addPin(){
        let location = locationManager.location
        locationManager.startUpdatingLocation()
        
        if location != nil {
            let event = Event(id: "New Event", lat: location!.coordinate.latitude, lon: location!.coordinate.longitude)
            self.addPin(event)
        }
        
        sharedInstance.eventsArray.append(address)
        
        locationManager.stopUpdatingLocation()
    }
    
    func addPin(event: Event) {
        locationManager.startUpdatingLocation()
        let location = CLLocation.init(latitude: event.lat, longitude: event.lon)
        let annotation = EventAnnotation(event: event)
        // Turn phone location into coordinates
        let locCoord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        // self.mapView.removeAnnotations(mapView.annotations)
        
        annotation.coordinate = locCoord
        annotation.title = event.id
//        annotation.subtitle = address
        
        self.mapView.addAnnotation(annotation)


    }
    
    
    
    
    @IBAction func changeMap(sender: AnyObject) {
        
        if mapType.selectedSegmentIndex == 0{
            mapView.mapType = MKMapType.Standard
        }
        
        if mapType.selectedSegmentIndex == 1{
            mapView.mapType = MKMapType.Satellite
        }
        
        if mapType.selectedSegmentIndex == 2{
            mapView.mapType = MKMapType.Hybrid
        }

        
        
    }
    

    @IBAction func toMenu(sender: AnyObject) {
        
        self.performSegueWithIdentifier("toMenu", sender: self)
        
        
    }
    
    
   //MARK: -Mapkit Delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        var placemark: CLPlacemark!
        
        //Reverse geocode function- complete
        
        if location != nil{
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if error == nil && placemarks!.count > 0 {
                placemark = placemarks![0] as CLPlacemark
                
                    if placemark.subThoroughfare != nil {
                        self.address = placemark.subThoroughfare! + " "
                    }
                    if placemark.thoroughfare != nil {
                        self.address = self.address + placemark.thoroughfare! + " "
                    }
                    if placemark.postalCode != nil {
                        self.address = self.address + placemark.postalCode! + ", "
                    }
                    if placemark.locality != nil {
                        self.address = self.address + placemark.locality! + " "
                    }
                    if placemark.administrativeArea != nil {
                        self.address = self.address + placemark.administrativeArea! + ", "
                    }
                    if placemark.country != nil {
                        self.address = self.address + placemark.country!
                    }
            }
        
        })
            
        }
        
        
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        
        self.mapView.setRegion(region, animated: true)
        
        
        
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error: " + error.localizedDescription)
    }

    func mapView (mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        
        let reuseId = "reuse"
        
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil{
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            pinView!.annotation = annotation
            
            if #available(iOS 9.0, *) {
                pinView!.pinTintColor = UIColor.orangeColor()
            } else {
                pinView?.pinColor = MKPinAnnotationColor.Red
                
            }
            pinView!.animatesDrop = true
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .InfoDark)
            
            
        }
        
        return pinView
        
    }
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let optionMenu = UIAlertController(title: nil, message: address, preferredStyle: .ActionSheet)
        
        
        let deleteAction = UIAlertAction(title: "Remove Pin", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let annotation = view.annotation as? EventAnnotation {
                annotation.event.delete()
                self.mapView.removeAnnotation(annotation)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }

    
  
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        print("pin pressed")
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            if id == "showEventManager" {
                if let vc = segue.destinationViewController as? EventManagerViewController {
                    vc.title = "Create an event"
                    vc.delegate = self
                }
            }
        }
    }
    
    
    func didFinishEditing(sender: EventManagerViewController) {
        
    }

    
    
    }