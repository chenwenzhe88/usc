//
//  SecondViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/13/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class MyCourseViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DropCourseDelegate, RegisterCourseDelegate{

    let regiesteredCellIdentifier: String = "MyCourseCell"
    let courseBinCellIdentifier: String = "MyCourseCell"
    let dropCourseToolCellIdentifier:String = "DropCourseToolCell"
    let addCourseToolCellIdentifier: String = "AddCourseToolCell"
    let cancelNum=0
    let doneNum=1
    let pickerNum=2
    let noneNum=3
    
    var expandedCells: NSMutableSet = NSMutableSet()
    var prevSelectedCellIndex: NSIndexPath?
    
    var registeredCourses: [Section]?
    var courseBin: [Section]?
    var terms: [Term]?
    var term: Term?
    var cancelBtn:UIBarButtonItem!
    var doneBtn:UIBarButtonItem!
    
    
    @IBOutlet weak var activeTerm: UITextField!
    @IBOutlet weak var dropCourseButton: UIButton!

    @IBOutlet weak var registerCourseButton: UIButton!

    var pickerViewWrapper: UIView!
    var termPickerView: UIPickerView!
    var mask:UIView!
    
    var hasRegisteredCourse: Bool {
        get {
            if let c = registeredCourses {
                return c.count > 0
            } else {
                return false
            }
        }
    }
    
    var hasCourseInCourseBin: Bool {
        get {
            if let c = courseBin {
                return c.count > 0
            } else {
                return false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // load data
        loadData()
        pickerViewWrapper = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 330, self.tableView.frame.width, 240))
        
        // add done button
        cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("cancelTermPicker"))
        doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("hideTermPicker"))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, pickerViewWrapper.frame.width, 40))
        toolBar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
        pickerViewWrapper.addSubview(toolBar)
        
        // set up term picker
        termPickerView = UIPickerView(frame: CGRectMake(0, 40, pickerViewWrapper.frame.width, 200))
        termPickerView.backgroundColor = UIColor.UIColorFromRGB(0xececec)
        termPickerView.delegate = self
        termPickerView.dataSource = self
        termPickerView.showsSelectionIndicator = true
        activeTerm.inputView = termPickerView
        activeTerm.text = shortTermDecription(term!)
        pickerViewWrapper.addSubview(termPickerView)
        pickerViewWrapper.layer.zPosition = 101
        pickerViewWrapper.hidden = true

        mask=UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, self.tableView.frame.height))
        mask.backgroundColor=UIColor.blackColor()
        mask.alpha=0.7
        mask.layer.zPosition=100
        mask.hidden=true
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "cancelTermPicker")
        mask.addGestureRecognizer(tapRec)

        // add mast and pickviewWrapper in order
        self.tableView.addSubview(mask)
        self.tableView.addSubview(pickerViewWrapper)
        
        // set up text field delegate
        activeTerm.delegate = self
        
        // set up refresh control
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        self.refreshControl?.endRefreshing()
        
    }
    
    func hideTermPicker(){

        self.mask.hidden=true
        pickerViewWrapper.hidden = true
        let row=termPickerView.selectedRowInComponent(0)
        if let t = terms {
            term = t[row]
            registeredCourses = DataAccess.retrieveRegisteredCourse(term: term!)
            courseBin = DataAccess.retrieveCoursebin(term: term!)
            
            self.activeTerm.text = shortTermDecription(t[row])
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

    func cancelTermPicker() {
        self.mask.hidden=true
        pickerViewWrapper.hidden = true
    }
    
    func loadData() {
        terms = DataAccess.retrieveTerms()
        if let t = terms {
            if term==nil{
                term = t[1]
            }
            registeredCourses = DataAccess.retrieveRegisteredCourse(term: term!)
            courseBin = DataAccess.retrieveCoursebin(term: term!)
        }
    }
    
    func reloadData() {
        loadData()
        
        self.tableView.reloadData()
        if self.refreshControl != nil {
            var formatter: NSDateFormatter = NSDateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
            var title: NSString = NSString(format: "Last update: %@", formatter.stringFromDate(NSDate()))
            var attributeTitle = NSAttributedString(string: String(title))
            self.refreshControl?.attributedTitle = attributeTitle
            
            self.refreshControl?.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let t = self.terms {
            return t.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if let t = self.terms {
            return t[row].description
        } else {
            return "empty"
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.mask.hidden=false
        self.pickerViewWrapper.hidden = false
        return false
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    // customize section header view
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 3 {
            return 0.01
        } else {
            return Constants.tableViewHeaderHeight
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        let headerTapRec = UITapGestureRecognizer()
        headerTapRec.addTarget(self, action: "hehe:")
        view.addGestureRecognizer(headerTapRec)
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = Constants.tableViewHeaderTextColor
        header.contentView.backgroundColor = Constants.tableViewHeaderBackgroundColor
        let headerTapRec = UITapGestureRecognizer()
        headerTapRec.addTarget(self, action: "hehe:")
        header.addGestureRecognizer(headerTapRec)
    }
    
    func hehe(sender:UITapGestureRecognizer){
        var lastRotation = CGFloat()
        var point = sender.locationInView(self.tableView)
        if elementTaped(point) == cancelNum{
            self.cancelTermPicker()
        }
        else if elementTaped(point) == doneNum{
            self.hideTermPicker()
        }
        else if elementTaped(point) == pickerNum{
            //picker move
            if (point.x < pickerViewWrapper.frame.midY+20){
                termPickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
        else{
            //do nothing
        }
    }
    
    func elementTaped(tapPoint:CGPoint) -> Int{
        if(pickerViewWrapper.frame.contains(tapPoint)){
            if(tapPoint.y < pickerViewWrapper.frame.minY+40 && tapPoint.y > pickerViewWrapper.frame.minY){
                if(tapPoint.x < self.tableView.frame.width/4){
                    return cancelNum
                }
                if(tapPoint.x > self.tableView.frame.width*3/4){
                    return doneNum
                }
                return noneNum
            }
            return pickerNum
        }
        return cancelNum
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3{
            return 0.01
        }
        if section % 2 == 1 {
            return 30.00
        }
        return 1.0
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Registered"
        case 2:
            return "Course Bin"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection: Int?
        
        switch section {
        case 0:
            rowsInSection = registeredCourses?.count
        case 2:
            rowsInSection = courseBin?.count
        default:
            rowsInSection = 1
        }

        if let row = rowsInSection {
            return row
        } else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String = ""
        var isRegisterdCell: Bool = false
        var isCoursebinCell: Bool = false

        switch indexPath.section {
        case 0:
            cellIdentifier = regiesteredCellIdentifier
            isRegisterdCell = true
        case 1:
            cellIdentifier = dropCourseToolCellIdentifier
        case 2:
            cellIdentifier = courseBinCellIdentifier
            isCoursebinCell = true
        case 3:
            cellIdentifier = addCourseToolCellIdentifier
        default: cellIdentifier = ""
        }
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell

        // var selectedView: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50.0))
        // selectedView.backgroundColor = UIColor.UIColorFromRGB(0xCCFFCC)
        // cell.selectedBackgroundView = selectedView
        
        if isRegisterdCell || isCoursebinCell {
            var courseCell: CourseDetailCell = cell as! CourseDetailCell
            
            var dataSourse:[Section]?
            if (isRegisterdCell) {
                dataSourse = registeredCourses
            } else {
                dataSourse = courseBin
            }
            
            if let courses = dataSourse {
                // set cell data
                let section: Section = courses[indexPath.row]
                courseCell.courseCode.text = section.course.sisId
                courseCell.courseTitle.text = section.course.title
                courseCell.courseUnits.text = "\(section.course.maxUnits)"
                courseCell.sectionCode.text = section.section
                courseCell.instructorName.text = section.instructor
                courseCell.classNum.text = section.session
                courseCell.classDays.text = section.day
                courseCell.classHours.text = "\(section.beginTime)-\(section.endTime)"
                courseCell.roomNum.text = section.location
                courseCell.numOfRegs.text = "\(section.registered)/\(section.seats)"
                courseCell.courseTitle.adjustsFontSizeToFitWidth=true
            }

            return courseCell
        } else {
            if (cellIdentifier == dropCourseToolCellIdentifier && hasRegisteredCourse) || (cellIdentifier == addCourseToolCellIdentifier && hasCourseInCourseBin) {
                if let button = cell.viewWithTag(1) as? UIButton {
                    button.hidden = false
                    button.layer.borderWidth=1
                    button.layer.cornerRadius=2
                }
                if let label = cell.viewWithTag(2) as? UILabel {
                    label.hidden = true
                }
            } else {
                if let button = cell.viewWithTag(1) as? UIButton {
                    button.hidden = true
                }
                if let label = cell.viewWithTag(2) as? UILabel {
                    label.hidden = false
                }

            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // decide a cell to expand or collapse
        
        if indexPath.section == 1 || indexPath.section == 3{
            return
        }
        let indexKey: String = "\(indexPath.section)+\(indexPath.row)"
        
        // multiple selection
        //if expandedCells.containsObject(indexKey) {
        //    expandedCells.removeObject(indexKey)
        //} else {
        //    expandedCells.addObject(indexKey)
        //}

        // single selection
        // set selected cell bgcolor
        // if let prev:NSIndexPath = prevSelectedCellIndex {
        //    tableView.cellForRowAtIndexPath(prev)?.backgroundColor = UIColor.whiteColor()
        // }
        // prevSelectedCellIndex = indexPath
        // tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.UIColorFromRGB(0xCCFFCC)
    
        if expandedCells.containsObject(indexKey) {
            expandedCells.removeAllObjects()
        } else {
            expandedCells.removeAllObjects()
            expandedCells.addObject(indexKey)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let indexKey: String = "\(indexPath.section)+\(indexPath.row)"
        if expandedCells.containsObject(indexKey) {
            return 178.0
        } else {
            if indexPath.section == 1 || indexPath.section == 3 {
                return 50
            }
            return 40.0
        }
    }
    
    // support editing cell
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 2 {
            let indexKey: String = "\(indexPath.section)+\(indexPath.row)"

            if expandedCells.containsObject(indexKey) {
                return true
            }
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            courseBin?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            DataAccess.persistCoursebin(courseBin!, term: term!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DropCourseSegue" {
            if let secondVC = segue.destinationViewController.topViewController as? DropCourseTableViewController {
                secondVC.delegate = self
                secondVC.registeredCourses = registeredCourses
            }
        }
        
        if segue.identifier == "RegisterCourseSegue" {
            if let secondVC = segue.destinationViewController.topViewController as? RegisterCourseTableViewController {
                secondVC.delegate = self
                secondVC.courseBin = courseBin
            }
        }
        
        if segue.identifier == "ToCalendar" {
            if let secondVC = segue.destinationViewController as? CalendarViewController {
                secondVC.scheduledCourses = courseBin!
                secondVC.registeredCourses = registeredCourses!
                secondVC.term = term
            }
        }
    }
    
    func removeRegisteredCourses(indexes: [Int]?) {
        if let ind = indexes {
            var removedIndexes: [Int] = ind
            removedIndexes.sort{$1 < $0}
            for i in removedIndexes {
                registeredCourses?.removeAtIndex(i)
            }
            
            DataAccess.persistRegisteredCourse(registeredCourses!, term: term!)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    func removeRegisteredCoursesFromCourseBin(indexes: [Int]?, newRegistered: [Section]?) {
        if let ind = indexes {
            var removedIndexes: [Int] = ind
            removedIndexes.sort{$1 < $0}
            for i in removedIndexes {
                courseBin?.removeAtIndex(i)
            }
        }
        if let new = newRegistered {
            for section in new {
                registeredCourses?.append(section)
            }
        }
        DataAccess.persistCoursebin(courseBin!, term: term!)
        DataAccess.persistRegisteredCourse(registeredCourses!, term: term!)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func shortTermDecription( term: Term ) -> String{
        var description = term.description
        return description.substringToIndex(advance(description.startIndex, 2)) + "-" + description.substringFromIndex(advance(description.endIndex, -2))
    }
}

