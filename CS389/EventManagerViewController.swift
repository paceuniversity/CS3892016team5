//
//  EventManagerViewController.swift
//  CS389
//
//  Created by Ian Carvalho on 4/18/16.
//  Copyright © 2016 Evis Lazimi. All rights reserved.
//

import UIKit

protocol EventManagerViewControllerDelegate: class {
    func didFinishEditing(sender: EventManagerViewController)
}


class EventManagerViewController: UIViewController {

    weak var delegate:EventManagerViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        delegate?.didFinishEditing(self)
    }

}
