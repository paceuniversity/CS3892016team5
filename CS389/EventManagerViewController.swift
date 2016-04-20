//
//  EventManagerViewController.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation

protocol EventManagerViewControllerDelegate: class {
    func didManageFinishEditingEvent(manager: EventManagerViewController, event: Event)
}


class EventManagerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    weak var delegate:EventManagerViewControllerDelegate?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        if self.event == nil {
            self.event = Event()
        }
        
        let address = self.addressField.text!
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.event?.lat = coordinates.latitude
                self.event?.lon = coordinates.longitude
                self.event?.desc = self.descriptionField.text!
                self.event?.address = self.addressField.text!
                self.event?.name = self.nameField.text!
                self.event?.creator = Singleton.sharedInstance.user!.id
                if let image = self.imageView.image {
                    self.event?.picture = self.encodeImage(image)
                }
                
                self.event?.save()
                self.navigationController?.popViewControllerAnimated(true)
                self.delegate?.didManageFinishEditingEvent(self, event: self.event!)
            }
        })
    }
    
    
    @IBAction func editDescription(sender: AnyObject) {
    }

    @IBAction func openLibrary(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.allowsEditing = false
        
        self.presentViewController(imagePicker, animated: true,
                                   completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.addButton.setImage(nil, forState: .Normal)
        self.imageView.image = image
    }
    
    func encodeImage(image: UIImage) -> String  {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        return imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
}
