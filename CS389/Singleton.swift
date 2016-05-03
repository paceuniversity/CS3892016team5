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
    
    var events = [String: Event]()
    var delegates = [EventAddedDelegate]()
    var user: User? = nil
    var mainController: MapViewController?
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
        
        
        let  eventRef = Firebase(url:"https://mutirao.firebaseio.com/events")
        // Attach a closure to read the data at our posts reference
        eventRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                let newEvent = Event(snapshot: child as! FDataSnapshot)
                self.events[snapshot.key] = newEvent
                dispatch_async(dispatch_get_main_queue(), {
                    for delegate in self.delegates {
                        delegate.didAddEvent(newEvent)
                    }
                })
            }
            for delegate in self.delegates {
                delegate.didEndAddingEvents(self.events)
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        eventRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let newEvent = Event(snapshot: snapshot)
            self.events[snapshot.key] = newEvent
            dispatch_async(dispatch_get_main_queue(), {
                for delegate in self.delegates {
                    delegate.didAddEvent(newEvent)
                    delegate.didEndAddingEvents(self.events)
                }
            });

        })
        
        eventRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.events.removeValueForKey(snapshot.key)
            dispatch_async(dispatch_get_main_queue(), {
                for delegate in self.delegates {
                    delegate.didEndAddingEvents(self.events)
                }
            });
            
        })

        
        
    }
    
    
}