//
//  EventViewController.swift
//  CS389
//
//  Created by Ian Carvalho on 4/20/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import MapKit

class EventViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    var locationManager = CLLocationManager()
    
    
    var event: Event?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        if let user = Singleton.sharedInstance.user {
            let created = user.eventsCreated.filter({ event in
                event.id == self.event?.id
            })
            if created.count > 0 {
                self.goButton.hidden = true
                self.cancelButton.hidden = false
                self.cancelButton.setTitle("Cancel Event", forState: .Normal)
                self.cancelButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                self.cancelButton.addTarget(self, action: #selector(cancel(_:)), forControlEvents: .TouchUpInside)
            } else {
                let attending = user.eventsAttending.filter({ event in
                    event.id == self.event?.id
                })
                
                if attending.count > 0 {
                    self.goButton.hidden = true
                    self.cancelButton.hidden = false
                    self.cancelButton.setTitle("Not Going", forState: .Normal)
                    self.cancelButton.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
                    self.cancelButton.addTarget(self, action: #selector(dontGo(_:)), forControlEvents: .TouchUpInside)

                }
            }
        }
        
        
        mapView.showsPointsOfInterest = true
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
        }
        
        if let event = self.event {
            descriptionField.text = event.desc
            addressField.text = event.desc
            nameField.text = event.name
            let decodedData = NSData(base64EncodedString: event.picture, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedimage = UIImage(data: decodedData!)
            
            // If no image, should not crash
            if decodedimage != nil{
            imageView.image = decodedimage! as UIImage
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.addPin(event!)
        self.title = event!.name
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(sender: AnyObject) {
        var items = [AnyObject]()
        if let image = self.imageView.image {
            items.append(image)
        }
        let text = "I am participating at the \(self.event!.name) event.\n Do some good today, download Mutirao app"
        items.append(text)
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        //
        
        self.presentViewController(activityVC, animated: true, completion: {
//            activityVC.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    

    @IBAction func go(sender: AnyObject) {
        event?.addAttendee(Singleton.sharedInstance.user!.id)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cancel(sender: AnyObject) {
        self.event!.delete()
    }
    
    func dontGo(sender: AnyObject) {
        self.event!.removeAttendee(Singleton.sharedInstance.user!.id)
    }

    func addPin(event: Event) {
        let location = CLLocation.init(latitude: event.lat, longitude: event.lon)
        let annotation = EventAnnotation(event: event)

        let locCoord = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: locCoord, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        
        self.mapView.setRegion(region, animated: true)
        
        annotation.coordinate = locCoord
        annotation.title = event.name
        annotation.subtitle = event.address
        
        self.mapView.addAnnotation(annotation)
        
        
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

 
}
