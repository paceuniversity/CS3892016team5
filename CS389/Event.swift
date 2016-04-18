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
    let lat: Double
    let lon: Double
    let id: String
    
    init(id: String, lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
        self.id = id
    }
    
    func delete() {
        let ref = Firebase(url: "https://mutirao.firebaseio.com/events/\(id)")
        ref.removeValue();
    }
    
}
