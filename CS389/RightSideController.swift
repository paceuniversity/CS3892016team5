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
        if Singleton.sharedInstance.events.isEmpty == false{
        return Singleton.sharedInstance.events.values.count
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
        let eventKey = Array(Singleton.sharedInstance.events.keys)[indexPath.row]
        cell.textLabel?.text = Singleton.sharedInstance.events[eventKey]!.name
        return cell 
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        rightTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let eventKey = Array(Singleton.sharedInstance.events.keys)[indexPath.row]
        let event = Singleton.sharedInstance.events[eventKey]
        delegate?.didSelectEvent(self, event: event!)
    }
    
  
    
    //MARK: - Tableview delegate methods
    func didAddEvent(event: Event) {
        
    }
    
    func didEndAddingEvents(events: [String: Event]) {
        self.tableView.reloadData()
    }
    
}