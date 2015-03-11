//
//  CourseListTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/14/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class CourseListTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!

    var term:Term?
    var department:Department?
    var courseList:[Course]?
    var filteredCourseList:[Course]?
    let courseCellIdentifier: String = "CourseListCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        if courseList == nil{
            courseList = DataAccess.retrieveCourseInDepartment( department! )
            filteredCourseList = courseList
        }
        
        searchBar.delegate = self
        
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
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return filteredCourseList!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseCellIdentifier, forIndexPath: indexPath) as! CourseTitleCell

        // Configure the cell...
        cell.courseCode.text = filteredCourseList![indexPath.row].sisId
        cell.courseTitle.text = filteredCourseList![indexPath.row].title
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            filteredCourseList = courseList
        }
        else {
            filteredCourseList = []
            for course:Course in courseList! {
                if (course.sisId.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil || course.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil){
                    filteredCourseList!.append(course)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    func refreshData(){
        courseList = DataAccess.retrieveCourseInDepartment( department! )
        filteredCourseList = courseList
        tableView.reloadData()
        searchBar.text = ""
        searchBar.endEditing(true)
        
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        var title: NSString = NSString(format: "Last update: %@", formatter.stringFromDate(NSDate()))
        var attributeTitle = NSAttributedString(string: String(title))
        refreshControl?.attributedTitle = attributeTitle
        refreshControl?.endRefreshing()
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.0
//    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! CourseDetailViewController
        let path = self.tableView.indexPathForSelectedRow()!
        controller.courseInfo = courseList?[path.row]
        controller.term = term
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
