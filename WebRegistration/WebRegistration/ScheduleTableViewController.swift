//
//  ScheduleTableViewController.swift
//  WebRegistration
//
//  Created by Amelech on 2/21/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    var DayInWeek:[String] = ["Monday","Tuesday","Wednesday","Thursday","Firday","Saturday","Sunday"]
    var DayInWeekShort:[String] = ["M","T","W","H","F","S"]

    var dataSource:[Section]!
    var sectionInWeek:[String:[Section]]!
    var myDayInWeek:UILabel!
    var myDayInYear:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataSource()
        processSectionData()

        myDayInWeek = UILabel(frame: CGRectMake(view.frame.width*3/10-50, 20,view.frame.width/2.5 + 100, 35))
        myDayInWeek.text = "Saturday"
        myDayInWeek.textAlignment = NSTextAlignment.Center
        myDayInWeek.textColor = UIColor.whiteColor()
        myDayInWeek.font = UIFont(name: "Helvetica Neue", size: 24.0)
        //dayInWeek.font.fontWithSize(20)
        
        myDayInYear = UILabel(frame: CGRectMake(view.frame.width*3/10-60, 60, view.frame.width/2.5 + 120, 20))
        myDayInYear.text = "Ferbruary 20th"
        myDayInYear.textColor = UIColor.whiteColor()
        myDayInYear.font = UIFont(name: "Helvetica Neue", size: 15.0)
        myDayInYear.textAlignment=NSTextAlignment.Center
        updateDate()
        
        var barView = UIView();
        barView.frame = CGRectMake(view.frame.width/4-10, 58, view.frame.width/2+20, 1)
        barView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        
        var headerView = UIView();
        headerView.backgroundColor = UIColor.clearColor()
        headerView.frame = CGRectMake(0, 0, 320, 100)
        headerView.addSubview(myDayInWeek)
        headerView.addSubview(myDayInYear)
        headerView.addSubview(barView)
        tableView.tableHeaderView = headerView;
        tableView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateDataInScheduleView", name:"UpdateDataInScheduleView", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        //println("Testing\(section)::\(DayInWeekShort[section])")
        if let tmpArray = sectionInWeek[DayInWeekShort[section]]{
            return tmpArray.count
        }
        else{
            return 1
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRectMake(0, 0, 320, 20))
        var label = UILabel(frame: CGRectMake(5, 7, 120, 15))
        label.font = UIFont(name: "Helvetica Neue", size: 16.0)
        view.addSubview(label)
        label.text = DayInWeek[section]
        label.textColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        view.backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 95.0/255.0, alpha: 0.98)
        return view
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6;
    }
    
    func updateDataInScheduleView(){
        updateTable()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //updateTable()
        var cell:ScheduleViewCell? = tableView.dequeueReusableCellWithIdentifier("ScheduleCell") as? ScheduleViewCell
        
        if let tmpSections:[Section] = sectionInWeek[DayInWeekShort[indexPath.section]]{
            if indexPath.row < tmpSections.count{
                let tmpSection:Section = tmpSections[indexPath.row]
                var tmpStr:String = tmpSection.location
            
            
                if tmpStr.rangeOfString("DEN") != nil {
                    tmpStr = "DEN"
                }
                cell!.courseLocation.text = tmpStr
                cell!.courseLocation?.textColor = UIColor.whiteColor()
        
                cell?.courseID?.text = tmpSection.course.sisId
                cell!.courseID?.textColor = UIColor.whiteColor()
        
                cell!.courseTime?.text = "\(tmpSection.beginTime) - \(tmpSection.endTime)"
                //cell!.courseTime?.textColor = UIColor.whiteColor()
                cell?.courseTitle.text = "Title: \(tmpSection.course.title)"
                //cell?.courseTitle.text = "Course Title: Adavance fuck tutorial with fundamentals of sucking dick"
            
                var instructor:String = ""
                if tmpSection.instructor != nil{
                    instructor = tmpSection.instructor!
                }
                cell?.courseInstructor.text = "Instuctor: \(instructor)"
        
                cell!.courseLocationBG?.layer.cornerRadius = 3.0
                cell!.courseLocationBG?.layer.masksToBounds = true
                cell!.courseLocationBG?.layer.shadowColor = UIColor.blackColor().CGColor
                cell!.courseLocationBG?.layer.shadowOffset = CGSizeMake(0.5, 0.5)
                cell!.courseLocationBG?.layer.shadowRadius = 5.0
                cell!.courseLocation.hidden = false;
                cell!.courseLocationBG.hidden = false;
                cell!.courseInstructor.hidden = false;
                cell!.courseID.hidden = false;
                cell!.courseTime.hidden = false;
                cell!.courseSLine.hidden = false;
                cell!.backgroundColor = UIColor.clearColor()
            }
            
        }
        else{
            //cell!.courseLocation.hidden = true;
            cell!.courseLocationBG.hidden = true;
            cell!.courseInstructor.hidden = true;
            cell!.courseID.hidden = true;
            cell!.courseTitle.text = "                    No Course";
            cell!.courseTime.hidden = true;
            cell!.courseSLine.hidden = true;
        }
        
        cell!.backgroundColor = UIColor.clearColor()
        cell!.backgroundView?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.4)
        return cell!
    }
    
    func updateTable(){
        updateDataSource()
        updateDate()
        processSectionData()
    }
    
    func updateDataSource(){
        dataSource = DataAccess.retrieveRegisteredCourse(term: Term(code:"20151", description: ""))
    }
    
    func updateDate(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.stringFromDate(date)
        myDayInWeek.text = dayOfWeekString
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        let dateString = formatter.stringFromDate(date)
        myDayInYear.text = dateString
    }
    
    func processSectionData(){
        sectionInWeek = [String: [Section]]()
        for section in dataSource {
            if section.day == nil{
                continue
            }
            for char in section.day!{

                var tmpSectionArr = sectionInWeek["\(char)"]
                if tmpSectionArr == nil{
                    tmpSectionArr = [Section]()
                    tmpSectionArr?.append(section)
                    sectionInWeek["\(char)"] = tmpSectionArr
                }
                else{
                    sectionInWeek["\(char)"]?.append(section)
                }
            }
        }
    }
}
