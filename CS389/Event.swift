//
//  Event.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase

class Event: NSObject {
    let syncProperties = ["lat", "lon", "address", "name", "desc", "creator", "picture"]
    
    let id: String
    
    var lat: Double
    var lon: Double
    
    var address: String = ""
    var name: String = ""
    var desc: String = ""
    
    var creator: String = ""
    
    var picture: String = ""
    
    var new = false
    
    init(id: String, lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        self.id = id
    }
    
    
    override init() {
        self.lat = 0
        self.lon = 0
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/")
        let evRef = ref.childByAutoId()
        id = evRef.key
        new = true
    }
    
    func delete() {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/\(id)")
        ref.removeValue();
    }
    
    func save() {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/\(id)")
        var value = [NSObject : AnyObject]()
        for prop in syncProperties {
            value[prop] = self.valueForKey(prop)
        }
        
        if new {
            ref.setValue(value)
        } else {
            ref.updateChildValues(value)
        }
    }
    
    func load(block: ((FDataSnapshot!) -> Void)!) {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/\(id)")
        
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for prop in self.syncProperties {
                if snapshot.hasChild(prop) {
                    self.setValue(snapshot.childSnapshotForPath(prop).value, forKey: prop)
                }
            }
            block(snapshot)
        })
    }
    
    func addAttendee(id: String) {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/\(self.id)/atendess/\(id)")
        ref.setValue(true)
        
    }
}
