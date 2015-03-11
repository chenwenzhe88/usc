//
//  CourseDetailViewController.swift
//  WebRegistration
//
//  Created by Wenzhe chen on 2/17/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class CourseDetailViewController:UITableViewController {
    var courseInfo:Course?
    var term: Term?
    var course_data:NSData?
    var sectionlist_data:NSData?
    let headerHeightForCourseDetailView:CGFloat=Constants.tableViewHeaderHeight
    let numberOfSection=2
    let courseDetailCellSectionNum=0
    let sectionDetailCellSectionNum=1
    let courseDetailCellHeight:CGFloat=120
    let sectionDetailCellHeight:CGFloat=172

    
    @IBAction func addCourse(sender: AnyObject) {
        var button=sender as! UIView
        let index=button.tag
        var json_sec=JSON(data:sectionlist_data!)
        var json_course=JSON(data:course_data!)
        var secJson=json_sec["V_SOC_SECTION"][index]
        var courseJson=json_course
        secJson["V_SOC_COURSE"]=courseJson
//        let s=secJson.rawString()
//        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
//        if ((dirs) != nil) {
//            let dir = dirs![0]; //documents directory
//            let path = dir.stringByAppendingPathComponent("mycoursebin.txt")
//            let manager = NSFileManager.defaultManager()
//            if (!manager.fileExistsAtPath(path)) {
//                manager.createFileAtPath(path, contents: nil, attributes: nil)
//            }
//            var text:String=String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
//            let len=count(text)
//            var result:String=""
//            if len>2{
//                let left=text.substringToIndex(advance(text.endIndex, -1))
//                let right=text.substringFromIndex(advance(text.endIndex, -1))
//                println("%s",left)
//                println("%s",right)
//                result=","+left+s!+right
//            }
//            else{
//                result="["+s!+"]"
//            }
//            result.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
//        }
        var newJson:JSON = [0]
        newJson[0] = secJson
        var newSection = Section.parseSection(newJson.rawData()!)
        var courseBinSection = DataAccess.retrieveCoursebin(term: term!)
        var isDuplicated = false
        for section in courseBinSection!{
            if section.id == newSection.id{
                isDuplicated = true
                break
            }
            
        }
        if !isDuplicated{
            courseBinSection?.append(newSection)
            DataAccess.persistCoursebin(courseBinSection!, term: term!)
        }
        
        var sec:Section?=courseInfo?.sectionList[index]
        self.addCourseSucceedAlert(sec!.section)
        
    }
    
    func addCourseSucceedAlert(section:String){
        var msg:String="Section "+section+" has been added to course bin"
        var alert = UIAlertController(title: "Succeed", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
//        var addCourseAlert: UIAlertView = UIAlertView()
//        addCourseAlert.delegate = self
//        addCourseAlert.title = "Succeed"
//        addCourseAlert.message = "Section "+section+" has been added to course bin"
//        addCourseAlert.addButtonWithTitle("OK")
//        addCourseAlert.show()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if courseInfo != nil{
            let course_data_string=courseInfo!.rawData
            course_data=(course_data_string! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            //            let url = NSURL(string: "http://http://petri.esd.usc.edu/socAPI/Courses/2014/\(courseInfo!.id)")
            //            let request = NSURLRequest(URL: url!)
            //            let sectionlist_data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            DataAccess.retrieveSections(courseInfo!, term: term!)
            sectionlist_data = (courseInfo!.rawData! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSection
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        var text: String;
        switch section{
        case 0: text = "Course Information"
        case 1: text = "Section List"
        default: text = ""
        }
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.text = text
        header.textLabel.textColor = Constants.tableViewHeaderTextColor
        header.contentView.backgroundColor = Constants.tableViewHeaderBackgroundColor
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeightForCourseDetailView
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == numberOfSection-1{
            return 0
        }
        return CGFloat(Constants.tableViewFooterHeight)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section==courseDetailCellSectionNum{
            return 1
        }
        return courseInfo!.sectionList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var id: String
        if indexPath.section==0{
            id="CourseDetailHeaderCell"
            let cell=tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! CourseDetailHeaderCell
            cell.courseNumber.text=courseInfo?.sisId
            cell.title.text=courseInfo?.title
            cell.units.text=String(format:"%.1f", courseInfo!.maxUnits)
            cell.title.adjustsFontSizeToFitWidth=true
            return cell
        }
        else{
            var row=indexPath.row
            id="CourseSectionCell"
            let cell=tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! SectionDetailCell
            var sectionList:[Section]=courseInfo!.sectionList
            cell.session.text=sectionList[row].session
            cell.section.text=sectionList[row].section
            cell.location.text=sectionList[row].location
            cell.days.text=sectionList[row].day
            cell.hours.text=sectionList[row].beginTime+"-"+sectionList[row].endTime
            cell.instructor.text=sectionList[row].instructor
            cell.regAndSeat.text="\(sectionList[row].registered)/\(sectionList[row].seats)"
            cell.type.text=sectionList[row].type;
            cell.wait.text="0";
            //cell.layer.borderWidth=2;
            //cell.Add.imageView?.contentMode=UIViewContentMode.ScaleAspectFit
            cell.Add.layer.borderWidth=1
            cell.Add.layer.cornerRadius=2;
            cell.Add.tag=row
            //cell.Add.layer.borderColor=UIColor().CGColor
            cell.outFrame.layer.borderWidth=2;
            cell.outFrame.layer.cornerRadius=4;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section==courseDetailCellSectionNum{
            return courseDetailCellHeight
        }
        else if indexPath.section==sectionDetailCellSectionNum{
            return sectionDetailCellHeight
        }
        else{
            return 0;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow()!
        if path.section == courseDetailCellSectionNum{
            
        }
        else if path.section == sectionDetailCellSectionNum{
        }
    }
    
    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
            return nil
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