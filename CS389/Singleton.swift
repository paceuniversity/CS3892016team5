//
//  Singleton.swift
//  CS389
//
//  Created by Evis Lazimi on 4/12/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import Foundation
import Firebase



// This class is a class to store any global objects in a singleton desgin pattern.
// Global variables here are initialized only once


class Singleton{
    
    
    static let sharedInstance = Singleton()
    
    var eventsArray = [String]()
    var user: User? = nil
    var profileImage: UIImage?
    var isloggedin = false
    
    
    private init(){
        let ref = Firebase(url: "https://mutirao.firebaseio.com")
        ref.observeAuthEventWithBlock({ authData in
            if authData != nil {
                let user = User(id: authData.uid, token: authData.token)
                self.user = user
            } else {
                self.user = nil
            }
        })
    }
    
    
}