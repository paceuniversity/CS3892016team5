//
//  EventAnnotation.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    var event: Event
    var coordinate : CLLocationCoordinate2D
    
    // Title and subtitle for use by selection UI.
    var title: String?
    var subtitle: String?
    var imageName: String?
    
    init(event: Event) {
        self.event = event
        self.coordinate = CLLocationCoordinate2D.init()
    }
    
}
