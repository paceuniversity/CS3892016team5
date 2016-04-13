//
//  Singleton.swift
//  CS389
//
//  Created by Evis Lazimi on 4/12/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import Foundation



// This class is a class to store any global objects in a singleton desgin pattern.
// Global variables here are initialized only once


class Singleton{
    
    
    static let sharedInstance = Singleton()
    
    var eventsArray = [String]()
    
    
    private init(){
        
    }
    
}