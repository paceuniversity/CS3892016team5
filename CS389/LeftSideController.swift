//
//  SideViewController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/19/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit



class LeftSideController: UITableViewController{

    @IBOutlet weak var sideTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.sideTableView.contentInset.top = self.view.frame.height / 4

        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
        
    }
    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        sideTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 2{
            
            let alert = UIAlertController(title: "Logout", message: "Are You Sure You Want To Log Out?", preferredStyle: .Alert)
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
                (_)in
                
                
                self.performSegueWithIdentifier("unwindToLogin", sender: self)
                
                
                
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                (_)in
            })
            
            alert.addAction(yesAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            

            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
}