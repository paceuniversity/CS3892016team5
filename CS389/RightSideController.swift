//
//  RightSideController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/28/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit



class RightSideController: UITableViewController{
    
    
    
    @IBOutlet weak var rightTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightTableView.delegate = self
        self.rightTableView.dataSource = self
        
        

        
        
    }
  
    
    
    
    //MARK: - Tableview delegate methods

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // Fill this part in to delete an event
            
            
        }
    }
    
    
 
    
    
    
}