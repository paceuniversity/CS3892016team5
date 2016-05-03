//
//  Model.swift
//  CS389
//
//  Created by Ian Carvalho on 4/28/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase

class Model: NSObject {
    var id: String
    var new: Bool = false
    
    
    convenience init(snapshot: FDataSnapshot) {
        self.init(new: false)
        self.sync(snapshot)
    }
    
    init(new: Bool = true) {
        id = ""
        self.new = new
        super.init()
        let ref = Firebase(url: self.dynamicType.refUrl())
        if new {
            let evRef = ref.childByAutoId()
            id = evRef.key
            
        }
    }
    

    
    func sync(snapshot: FDataSnapshot) {
        self.id = snapshot.key
        for prop in self.syncProperties() {
            if snapshot.hasChild(prop) {
                self.setValue(snapshot.childSnapshotForPath(prop), prop: prop)
            }
        }
    }
    
    func syncProperties() -> [String] {
        return [String]()
    }
    
    class func refUrl() -> String {
        return ""
    }
    
    init(id: String, block: ((FDataSnapshot!) -> Void)! = { snapshot in }) {
        self.id = id
        super.init()
        self.load(block)
    }
    
    func load(block: ((FDataSnapshot!) -> Void)!) {
        let ref = Firebase(url: "\(self.dynamicType.refUrl())\(id)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.sync(snapshot)
            block(snapshot)
        })
    }
    
    func delete() {
        let ref = Firebase(url: "\(self.dynamicType.refUrl())\(id)")
        ref.removeValue();
    }
    
    func save() {
        let ref = Firebase(url: "\(self.dynamicType.refUrl())\(id)")
        var value = [NSObject : AnyObject]()
        for prop in self.syncProperties() {
            value[prop] = self.valueForKey(prop)
        }
        
        if new {
            ref.setValue(value)
        } else {
            
            ref.updateChildValues(value)
        }
    }
    
    
    func setValue(snapshot: FDataSnapshot, prop:String) {
        self.setValue(snapshot.value, forKey: prop)
    }
}
