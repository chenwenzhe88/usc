//
//  MajorListTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/14/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class MajorListTableViewController: UITableViewController {

    var school: School?
    var term: Term?
    let majorCellIdentifier: String = "MajorCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.school != nil){
            if !self.school!.hasDepartment{
            //let url = NSURL(string: "http://petri.esd.usc.edu/socAPI/Schools/"+school!.code)
            //let request = NSURLRequest(URL: url!)
            //let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
                DataAccess.retrieveDepartments(school)
            }
        }
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.school!.departmentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(majorCellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let label = cell.subviews[0].subviews[0] as! UILabel
        label.text = self.school!.departmentList[indexPath.row].description

        return cell
    } 

//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.0
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var path = self.tableView.indexPathForSelectedRow()
        let controller = segue.destinationViewController as! CourseListTableViewController
        controller.department = school?.departmentList[path!.row]
        controller.term = term
    }
    
    func refreshData(){
        school?.hasDepartment = false
        DataAccess.retrieveDepartments(school)
        tableView.reloadData()
        
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        var title: NSString = NSString(format: "Last update: %@", formatter.stringFromDate(NSDate()))
        var attributeTitle = NSAttributedString(string: String(title))
        refreshControl?.attributedTitle = attributeTitle
        refreshControl?.endRefreshing()
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
