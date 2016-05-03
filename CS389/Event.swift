//
//  Event.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import Firebase

protocol EventAddedDelegate: class {
    func didAddEvent(event: Event)
    func didEndAddingEvents(events: [String: Event])
}


class Event: Model {
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    var address: String = ""
    var name: String = ""
    var desc: String = ""
    
    var creator: String = ""
    
    var picture: String = ""
    
    override class func refUrl() -> String {
        return "https://mutirao.firebaseio.com/events/"
    }
    
    func addAttendee(id: String) {
        let ref = Firebase(url: "\(Event.refUrl())\(self.id)/atendess/\(id)")
        Singleton.sharedInstance.user?.eventsAttending[self.id] = true
        Singleton.sharedInstance.user?.save()
        ref.setValue(true)
        
    }
    
    func removeAttendee(id: String) {
        let ref = Firebase(url: "\(Event.refUrl())\(self.id)/atendess/\(id)")
        Singleton.sharedInstance.user?.eventsAttending.removeValueForKey(self.id)
        Singleton.sharedInstance.user?.save()
        ref.removeValue()
        
    }
    
    override func syncProperties() -> [String] {
         return ["lat", "lon", "address", "name", "desc", "creator", "picture"]
    }
}

