//
//  ProfileView.swift
//  CS389
//
//  Created by Evis Lazimi on 4/25/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase


class ProfileView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var descText: UITextField!
    
    @IBOutlet weak var mailText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Firebase(url: "https://mutirao.firebaseio.com/users/\(Singleton.sharedInstance.user!.id)")
        
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
//        self.profileImage.layer.borderWidth = 2
//        self.profileImage.layer.zPosition = 2
        self.profileImage.contentMode = UIViewContentMode.ScaleAspectFill
        
            ref.observeEventType(.Value, withBlock: { snapshot in
                
                if snapshot.hasChild("picture") {
                    
                    let profileString = snapshot.value.objectForKey("picture") as! String
                    if profileString != "" {
                        let decodedData = NSData(base64EncodedString: profileString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                        Singleton.sharedInstance.profileImage = UIImage(data: decodedData!)
                        self.profileImage.image = Singleton.sharedInstance.profileImage
                    }
                }
                
                self.nameText.text = snapshot.value.objectForKey("name") as? String
                self.descText.text = snapshot.value.objectForKey("description") as? String
                self.mailText.text = snapshot.value.objectForKey("email") as? String
                
                
               
        })
        
        let tapImage = UITapGestureRecognizer(target:self, action:#selector(ProfileView.profileImageTapped(_:)))
        
        // Add touch to update profile picture
        self.profileImage.addGestureRecognizer(tapImage)
    }
    
    func profileImageTapped(sender: UITapGestureRecognizer){
     
        pickImage()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func saveButton(sender: AnyObject) {
        
        let ref = Firebase(url: "https://mutirao.firebaseio.com/users/\(Singleton.sharedInstance.user!.id)")
        
        let profileStrings = ["name" : nameText.text!, "description" : descText.text!, "email": mailText.text!]
        
            
           ref.updateChildValues(profileStrings)
            
            let alert = UIAlertView()
            alert.title = "Action"
            alert.message = "Information Updated!"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        
       
        
        
    }
    
    
    func pickImage(){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true,
                                   completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.dismissViewControllerAnimated(true, completion: {
            self.uploadProfilePic(image)
        })
    }
    


    func uploadProfilePic(imageToUpload: UIImage){
      
        let ref = Firebase(url: "https://mutirao.firebaseio.com/users/\(Singleton.sharedInstance.user!.id)")
    
        let base64ImageData = UIImageJPEGRepresentation(imageToUpload, 0.2)?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        let profileData = ["picture" : base64ImageData! ]

        ref.updateChildValues(profileData, withCompletionBlock: { error, result in
            
            if error != nil{
                print("Error" + error.localizedDescription)
            }
            
            else{
             
                self.profileImage.image = Singleton.sharedInstance.profileImage
                
            }
            
        })

    
    }
}
