//
//  EventViewController.swift
//  CS389
//
//  Created by Ian Carvalho on 4/20/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var event: Event?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = self.event {
            descriptionField.text = event.desc
            addressField.text = event.desc
            nameField.text = event.name
            let decodedData = NSData(base64EncodedString: event.picture, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedimage = UIImage(data: decodedData!)
            
            imageView.image = decodedimage! as UIImage
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func go(sender: AnyObject) {
        
        event?.addAttendee(Singleton.sharedInstance.user!.id)
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
