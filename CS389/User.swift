//
//  User.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit

class User: NSObject {
    let id: String
    let token: String
    
    init(id: String, token: String) {
        self.id = id
        self.token = token
    }
}
