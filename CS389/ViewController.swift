//
//  ViewController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/7/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var passwordBox: UITextField!

    @IBOutlet weak var userNameBox: UITextField!
    
 
    

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        passwordBox.delegate = self
        userNameBox.delegate = self
        

        
        
    
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    
        userNameBox.text = ""
        passwordBox.text = ""
        
    }
    
  
    @IBAction func unwindToLogIn(sender: UIStoryboardSegue){
    
          
    self.navigationController?.popViewControllerAnimated(true)
               
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissKeyboard(){
        view.endEditing(true)
        
    }
    
    
    
    @IBAction func logInAction(sender: AnyObject) {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/users")
        
        ref.authUser(self.userNameBox.text, password: self.passwordBox.text,
                     withCompletionBlock: { (error, auth) -> Void in
                        if error == nil {
                    print (auth)
                            
                        self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                        else {
                            print(error)
                        }
        })
    }
    
    
    
    @IBAction func signUpAction(sender: AnyObject) {
        var createUserText: UITextField!
        var createPasswordText: UITextField!
        
        
        let signUpView = UIAlertController(title: "Create Account", message: "Please create a username and password", preferredStyle: .Alert)
        
        
        signUpView.addTextFieldWithConfigurationHandler { (textField) in
           
            createUserText = textField
            textField.placeholder = "Email"
            textField.keyboardType = .EmailAddress
            
            
            
        }
        
        signUpView.addTextFieldWithConfigurationHandler { (textField) in
            
            createPasswordText = textField
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            
        }
        
        let createAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: {
            (_)in
            
            let ref = Firebase(url: "https://mutirao.firebaseio.com/users")
            
            if createUserText.text != "" && createPasswordText.text != ""{
            
            ref.createUser(createUserText.text, password: createPasswordText.text, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    print(error.localizedDescription)
                }
                
                else{
                    
                    //Create the record in the database with values email, password, picture and last location
                    ref.authUser(createUserText.text, password: createPasswordText.text, withCompletionBlock: { (error, auth) in
                        
                        let user = ["email": createUserText.text, "password": auth.provider, "picture": "", "last_location" : ""]
                        
                        ref.childByAppendingPath(auth.uid).setValue(user)
                        

                        
                    })
                }
                
                
                })
                    
                
            }
        })
        
          signUpView.addAction(createAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (_)in
            
            createUserText.text = ""
            createPasswordText.text = ""
            
            
        })

      
        signUpView.addAction(cancelAction)
        
        self.presentViewController(signUpView, animated: true, completion: nil)
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

