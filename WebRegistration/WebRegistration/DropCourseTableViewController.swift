//
//  DropCourseTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/16/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

protocol DropCourseDelegate : class {
    func removeRegisteredCourses(indexes:[Int]?)
}

class DropCourseTableViewController: UITableViewController {

    let dropCourseCellIdentifier: String = "DropCourseCell"
    
    var registeredCourses: [Section]?
    
    var delegate: DropCourseDelegate?
    
    var selectedRows: NSMutableSet = NSMutableSet()
    
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
    
    @IBAction func cancelDrop(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitDrop(sender: AnyObject) {
        
        if self.selectedRows.count == 0 {
            var noSelectionAlert = UIAlertController(title: "No Course Selected", message: "Please select the courses to drop.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            noSelectionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                // do nothing
            }))
            self.presentViewController(noSelectionAlert, animated: true, completion: nil)
            
        } else {
            var submitAlert = UIAlertController(title: "Confirm", message: "Are you sure to drop the selected courses?", preferredStyle: UIAlertControllerStyle.Alert)
            submitAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: {(action: UIAlertAction!) in
                // do nothing
            }))

            submitAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(action: UIAlertAction!) in
                // submit
                
                // dismiss vc
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.removeRegisteredCourses(self.selectedRows.allObjects as? [Int])
            }))
            
            
            self.presentViewController(submitAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let course = registeredCourses {
            return course.count
        } else  {
            return 0
        }
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CourseTitleCell = tableView.dequeueReusableCellWithIdentifier(dropCourseCellIdentifier) as! CourseTitleCell

        // Configure the cell...
        if let courses = registeredCourses {
            cell.courseCode?.text = courses[indexPath.row].course.sisId
            cell.courseTitle?.text = courses[indexPath.row].course.title
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = .Checkmark
        cell.backgroundColor = UIColor.UIColorFromRGB(0x99CC99) //UIColor.UIColorFromRGB(0xFFA319)
        selectedRows.addObject(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        cell.accessoryType = .None
        cell.backgroundColor = UIColor.whiteColor()
        selectedRows.removeObject(indexPath.row)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
