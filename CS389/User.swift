//
//  User.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase

class User: Model {
    let token: String
    var eventsAttending = [Event]()
    var eventsCreated = [Event]()
    
    init(id: String, token: String, block: ((FDataSnapshot!) -> Void)! = { snapshot in }) {
        self.token = token
        super.init(id: id, block: block)
    }
    
    override class func refUrl() -> String {
        return "https://mutirao.firebaseio.com/users/"
    }
    
}
