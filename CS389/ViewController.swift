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
        let ref = Firebase(url: "https://mutirao.firebaseio.com")
        ref.authUser(self.userNameBox.text, password: self.passwordBox.text,
                     withCompletionBlock: { (error, auth) -> Void in
                        if error == nil {
                            print (auth)
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            print(error)
                        }
        })
    }
    
    
    
    @IBAction func signUpAction(sender: AnyObject) {
        let ref = Firebase(url: "https://mutirao.firebaseio.com")
        ref.createUser(userNameBox.text, password: passwordBox.text) { (error: NSError!) in
            if error == nil {
                self.logInAction(sender)
            } else {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

