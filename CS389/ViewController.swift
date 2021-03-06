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
        let ref = Firebase(url: "https://mutirao.firebaseio.com/2")
        let alert = UIAlertView()
        alert.title = "Error"
        alert.addButtonWithTitle("Ok")
      
        
        ref.authUser(self.userNameBox.text, password: self.passwordBox.text,
                     withCompletionBlock: { (error, auth) -> Void in
                        if error == nil {
                    print (auth)
                            
                        self.navigationController?.popViewControllerAnimated(true)
                        }
                        
                        else {
                            
                            if let errorCode = FAuthenticationError(rawValue: error.code){

                                switch (errorCode) {
                                    
                                case .EmailTaken:
                                    alert.message = "This email address already exists"
                                    alert.show()
                                
                                case .InvalidEmail:
                                    alert.message = "Invalid email address. Please enter a valid email"
                                    alert.show()
                                    
                                case .InvalidPassword:
                                    alert.message = "Invalid password. Please try again"
                                    alert.show()
                                    
                                case .NetworkError:
                                    alert.message = "No internet connection. Please try again later"
                                    alert.show()
                                    
                                default:
                                    
                                    alert.message = "Unknown error. If error continues, please contact help"
                                    alert.show()
                    
                                }
 
                            }
                            
                            
                            
                            
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
            let alert = UIAlertView()
            alert.title = "Error"
            alert.addButtonWithTitle("Ok")
            
            
            if createUserText.text != "" && createPasswordText.text != ""{
            
            ref.createUser(createUserText.text, password: createPasswordText.text, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    print(error.localizedDescription)
                    
                    if let errorCode = FAuthenticationError(rawValue: error.code){
                        
                        switch (errorCode) {
                            
                        case .EmailTaken:
                            alert.message = "This email address already exists"
                            alert.show()
                            
                        case .InvalidEmail:
                            alert.message = "Invalid email address. Please enter a valid email"
                            alert.show()
                            
                        case .InvalidPassword:
                            alert.message = "Invalid password. Please try again"
                            alert.show()
                            
                        case .NetworkError:
                            alert.message = "No internet connection. Please try again later"
                            alert.show()
                            
                        default:
                            
                            alert.message = "Unknown error. If error continues, please contact help"
                            alert.show()
                            
                        }
                    }
                    

                }
                
                else{
                    
                    //Create the record in the database with values email, password, picture and last location
                    ref.authUser(createUserText.text, password: createPasswordText.text, withCompletionBlock: { (error, auth) in
                        
                        let user = ["email": createUserText.text, "password": auth.provider, "picture": "", "last_location" : ""]
                        
                        if error != nil{
                            
                            if let errorCode = FAuthenticationError(rawValue: error.code){
                                
                                switch (errorCode) {
                                    
                                case .EmailTaken:
                                    alert.message = "This email address already exists"
                                    alert.show()
                                    
                                case .InvalidEmail:
                                    alert.message = "Invalid email address. Please enter a valid email"
                                    alert.show()
                                    
                                case .InvalidPassword:
                                    alert.message = "Invalid password. Please try again"
                                    alert.show()
                                    
                                case .NetworkError:
                                    alert.message = "No internet connection. Please try again later"
                                    alert.show()
                                    
                                default:
                                    
                                    alert.message = "Unknown error. If error continues, please contact help"
                                    alert.show()
                                    
                                }
                            }

                        }
                        
                        else{
                        
                            ref.childByAppendingPath(auth.uid).setValue(user)
                            let alert2 = UIAlertView()
                            alert2.title = "Success!"
                            alert2.message = "Account successfully created!"
                            alert2.addButtonWithTitle("OK")
                            alert2.show()
                        
                        }
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

