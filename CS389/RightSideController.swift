//
//  RightSideController.swift
//  CS389
//
//  Created by Evis Lazimi on 3/28/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit


protocol RightSideControllerDelegate: class {
    func didSelectEvent(sender: RightSideController, event: Event)
}

class RightSideController: UITableViewController, EventAddedDelegate{
    
    
    
    @IBOutlet weak var rightTableView: UITableView!
    weak var delegate: RightSideControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rightTableView.delegate = self
        self.rightTableView.dataSource = self
   
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Singleton.sharedInstance.eventsArray.isEmpty == false{
        return Singleton.sharedInstance.eventsArray.count
    }
        else {
            
         return 0
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cellIdentifier = "cell"
        
        // This is used so that we do not keep allocating new cells when off the screen
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        // if no cells, create one
        if (cell == nil) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = Singleton.sharedInstance.eventsArray[indexPath.row].name
        return cell 
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        rightTableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.didSelectEvent(self, event: Singleton.sharedInstance.eventsArray[indexPath.row])
    }
    
  
    
    //MARK: - Tableview delegate methods
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // Fill this part in to delete an event
            Singleton.sharedInstance.eventsArray.removeAtIndex(indexPath.row)
            rightTableView.reloadData()
            
            
        }
    }
    
    func didAddEvent(event: Event) {
        
    }
    
    func didEndAddingEvents(events: [Event]) {
        self.tableView.reloadData()
    }
    
}