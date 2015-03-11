//
//  SemesterTableViewController.swift
//  WebRegistration
//
//  Created by ADMIN on 2/20/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class SemesterTableViewController: UITableViewController {
    
    var terms:[Term]?
    let cellIdentifier = "SemesterIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if terms == nil{
            return 0
        }
        return terms!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = terms![indexPath.row].description
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let path = self.tableView.indexPathForSelectedRow()!
        self.navigationController?.popViewControllerAnimated(true)
        let targetController = self.navigationController?.topViewController as! RegistrationTableViewController
        targetController.thisTerm = terms![path.row]
        targetController.loadSchool()
        targetController.tableView.reloadData()
    }
    
}