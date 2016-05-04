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
    var eventsAttending = [String: Bool]()
    var eventsCreated = [String: Bool]()
    var name: String = ""
    var desc: String = ""
    var picture: String = ""
    
    init(id: String, token: String, block: ((FDataSnapshot!) -> Void)! = { snapshot in }) {
        self.token = token
        super.init(id: id, block: block)
    }
    
    override class func refUrl() -> String {
        return "https://mutirao.firebaseio.com/users/"
    }
    
    override func syncProperties() -> [String] {
        return ["eventsAttending", "eventsCreated"]
    }
    
    override func setValue(snapshot: FDataSnapshot, prop:String) {
        if prop == "eventsAttending" || prop == "eventsCreated" {
            var dictProp = [String: Bool]()
            for child in snapshot.children {
                dictProp[child.key] = true
            }
            self.setValue(dictProp, forKey: prop)
        }
        else {
            super.setValue(snapshot, forKey: prop)
        }
    }
}
