//
//  AboutMenuController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/22/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import Foundation
import UIKit
import Social

class AboutMenu: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIImageView!
    @IBOutlet weak var githubBtn: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fbTap = UITapGestureRecognizer(target: self, action: #selector(AboutMenu.fbTap(_:)))
        let gitTap = UITapGestureRecognizer(target: self, action: #selector(AboutMenu.githubTap(_:)))
        
        
        facebookBtn.addGestureRecognizer(fbTap)
        githubBtn.addGestureRecognizer(gitTap)
        
        
        
        
    }
    
    
    func fbTap(sender:UITapGestureRecognizer){
        let url = NSURL(string: "https://www.facebook.com/mutiraoapp")!
        
        UIApplication.sharedApplication().openURL(url)
        
        
        
        
    }
    
    func githubTap(sender: UITapGestureRecognizer){
        let url = NSURL(string: "https://github.com/paceuniversity/CS3892016team5/wiki")!
      
        UIApplication.sharedApplication().openURL(url)
        
        
        
        
    }
    

    
}