//
//  RegistrationTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/14/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    let identifierList:[String] = ["SemesterCell", "MyMajorCell","DepartmentCell"]
    var schools: [School]?
    var terms:[Term]?
    var thisTerm: Term?
    var myDepartment:Department?
    var footerHeight:CGFloat = Constants.tableViewFooterHeight
    var headerHeight:CGFloat = Constants.tableViewHeaderHeight

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if terms == nil{
            //let url = NSURL(string: "http://petri.esd.usc.edu/socAPI/Terms")
            //let request = NSURLRequest(URL: url!)
            //let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            loadTerm()
            self.thisTerm = terms?[1]
        }

        if schools == nil{
            loadSchool()
            myDepartment = Department(code: "CSCI", description: "Computer Science", school: schools![0]);
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var text: String;
        switch section{
            case 0: text = "Registration Semester"
            case 1: text = "My Major"
            case 2: text = "School List"
            default: text = ""
        }

        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.text = text
        header.textLabel.textColor = Constants.tableViewHeaderTextColor
        header.contentView.backgroundColor = Constants.tableViewHeaderBackgroundColor
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 2{
            return footerHeight
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 40.0
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 2{
            return schools!.count
        }
        else {
          return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifierList[indexPath.section], forIndexPath: indexPath) as! UITableViewCell

        var text: String
        
        // Configure the cell...
        switch indexPath.section{
        
        case 0: text = self.thisTerm!.description
        case 1: text = myDepartment!.description
        case 2: text = schools![indexPath.row].description
        default: text = ""
        }
        
        let label = cell.subviews[0].subviews[0] as! UILabel
        label.text = text
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow()!
        if path.section == 0{
            let controller = segue.destinationViewController as! SemesterTableViewController
            controller.terms = terms
        }
        if path.section == 1{
            let controller = segue.destinationViewController as! CourseListTableViewController
            controller.department = myDepartment
            controller.term = thisTerm
        }
        else if path.section == 2{
            let controller = segue.destinationViewController as! MajorListTableViewController
            controller.school = schools?[path.row]
            controller.term = thisTerm
        }
    }
    
    func loadSchool(){
        self.schools = DataAccess.retrieveSchools()
    }
    
    func loadTerm(){
        terms = DataAccess.retrieveTerms()
    }
    
    func refreshData(){
        loadTerm()
        loadSchool()
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
