//
//  RegisterCourseTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/16/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

protocol RegisterCourseDelegate: class {
    func removeRegisteredCoursesFromCourseBin(indexes: [Int]?, newRegistered: [Section]?)
}

class RegisterCourseTableViewController: UITableViewController {
    
    let registerCourseCellIdentifier: String = "RegisterCourseCell"
    var courseBin: [Section]?
    
    var selectedRows: NSMutableSet = NSMutableSet()
    
    var delegate: RegisterCourseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelRegister(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitRegister(sender: AnyObject) {
        
        if self.selectedRows.count == 0 {
            var noSelectionAlert = UIAlertController(title: "No Course Selected", message: "Please select the courses to drop.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            noSelectionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                // do nothing
            }))
            self.presentViewController(noSelectionAlert, animated: true, completion: nil)
        } else {
            var submitAlert = UIAlertController(title: "Confirm", message: "Are you sure to register the selected courses?", preferredStyle: UIAlertControllerStyle.Alert)
            submitAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: {(action: UIAlertAction!) in
                // do nothing
            }))
            
            submitAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) in
                // submit
                
                // dismiss vc
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                // update in mycourse view
                var newRegistered: [Section]? = []
                if let selected = self.selectedRows.allObjects as? [Int] {
                    if let courses = self.courseBin {
                        for i in selected {
                            newRegistered?.append(courses[i])
                        }
                    }
                }
                self.delegate?.removeRegisteredCoursesFromCourseBin(self.selectedRows.allObjects as? [Int], newRegistered: newRegistered)
            }))
            
            self.presentViewController(submitAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let course = courseBin {
            return course.count
        } else  {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CourseTitleCell = tableView.dequeueReusableCellWithIdentifier(registerCourseCellIdentifier) as! CourseTitleCell
        
        if let courses = courseBin {
            cell.courseCode?.text = courses[indexPath.row].course.sisId
            cell.courseTitle?.text = courses[indexPath.row].course.title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = .Checkmark
        cell.backgroundColor = UIColor.UIColorFromRGB(0x99CC99)
        selectedRows.addObject(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = .None
        cell.backgroundColor = UIColor.whiteColor()
        selectedRows.removeObject(indexPath.row)
    }
}
