//
//  MyCoursesCalendarViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/14/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var registeredCourses: [Section] = []
    var scheduledCourses: [Section] = []
    var conflictCourse: [Section] = []

    var sectionDictionary = Dictionary<SubSection, Int>()
    
    let REGISTERED_COURSE_TYPE = 0
    let SCHEDULED_COURSE_TYPE = 1
    let CONFLICT_COURSE_TYPE = 2
    let CONFLICT_ALPHA: CGFloat = 0.5
    let HEAD_HEIGHT:CGFloat = 25
    let HOURE_WIDTH:CGFloat = 33
    let GRID_WIDTH:CGFloat = 273
    let VIEW_WIDTH:CGFloat = 38
    let HOUR_HEIGHT:CGFloat = 35
    
    let HOUR_TAG = 10
    let GRID_TAG = 20
    let COURSE_TAG = 30
    
    let colorDictionary = [ 0: UIColor.UIColorFromRGB(0x99CC99),
                            1: UIColor.orangeColor(),
                            2: Constants.tableViewHeaderBackgroundColor]
    
    var courseDetailPopover: UIAlertController?
    var refreshControl : UIRefreshControl?
    var term: Term?
    
    let calendarStartHour:Int = 6
    let dayText = [0: "Sun", 1: "Mon", 2:"Tue", 3:"Wen", 4:"Thu", 5:"Fri", 6:"Sat"]
    let dayDictionary: Dictionary<Character, Int> = ["M":2 , "T":3, "W":4 , "H":5, "F":6]
    
    var tappedSubSection: SubSection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setView()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: Selector("reloadData"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func revealConflict(){
        for (section1:SubSection, type: Int) in sectionDictionary{
            if type == REGISTERED_COURSE_TYPE || type == CONFLICT_COURSE_TYPE{
                continue
            }
            for section2 in sectionDictionary.keys{
                if section1 != section2 && isOverlap(section1, subsection2: section2){
                    sectionDictionary[section1] = CONFLICT_COURSE_TYPE
                    sectionDictionary[section2] = CONFLICT_COURSE_TYPE
                }
            }
        }
    }
    
    func isOverlap( subsection1: SubSection, subsection2: SubSection ) -> Bool{
        if subsection1.day != subsection2.day{
            return false
        }
        let section1 = subsection1.section!
        let section2 = subsection2.section!
        
        if isNotLess( section1.endTime, time2: section2.beginTime ) || isNotLess(section2.endTime, time2: section1.beginTime){
            return false
        }
        else {
            return true
        }
    }
    
    func isNotLess( time1: String, time2: String ) -> Bool{
        var hour1 = time1.substringToIndex(advance(time1.startIndex, 2)).toInt()!
        var minute1 = time1.substringFromIndex(advance(time1.endIndex, -2)).toInt()!
        
        var hour2 = time2.substringToIndex(advance(time2.startIndex, 2)).toInt()!
        var minute2 = time2.substringFromIndex(advance(time2.endIndex, -2)).toInt()!
        
        return hour2 > hour1 || (hour1 == hour2 && minute2 >= minute1)
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        if let tappedView = recognizer.view as? SubSection {
            tappedSubSection = tappedView
            
            // create popover with alert
            courseDetailPopover = UIAlertController(title: "", message: "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.Alert)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("cancelPopover"))
            courseDetailPopover!.view.addGestureRecognizer(tapRecognizer)
            
            // present course info
            let section = tappedView.section!
            
            var codeLabel: UILabel = createLabel(10, 10, 100, 50, section.course.sisId)
            codeLabel.textColor = UIColor.UIColorFromRGB(0x007AFF)
            codeLabel.font = UIFont(name: "Optima", size: 15)
            var titleLabel: UILabel = createLabel(100, 10, 150, 50, section.course.title)
            titleLabel.textColor = UIColor.UIColorFromRGB(0x007AFF)
            titleLabel.font = UIFont(name: "Optima", size: 14)
            
            var sectionLabel: UILabel = createLabel(10, 60, 100, 30, "Section: \(section.section)")
            var unitsLabel: UILabel = createLabel(160, 60, 100, 30, "Units: \(section.course.maxUnits)")
            
            var hoursLabel: UILabel = createLabel(10, 90, 130, 30, "Hours: \(section.beginTime)-\(section.endTime)")
            var daysLabel: UILabel = createLabel(160, 90, 100, 30, "Days: \(section.day!)")
            
            var instructor = ""
            if section.instructor != nil{
                instructor = section.instructor!
            }
            var instructorLabel: UILabel = createLabel(10, 150, 200, 30, "Instructor: \(instructor)")
            var locationLabel: UILabel = createLabel(10, 120, 200, 30, "Loacation: \(section.location)")
            
            var btnTitle: String = ""
            if tappedView.type == SCHEDULED_COURSE_TYPE {

                btnTitle = "Unschedule"
                
                var button: UIButton = UIButton(frame: CGRectMake(95, 190, 80, 25))
                button.addTarget(self, action: "removeTappedSubSection", forControlEvents: UIControlEvents.AllTouchEvents)
                button.setTitle(btnTitle, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                button.titleLabel?.font = UIFont(name: "Optima", size: 13)
                button.titleLabel?.tintColor = UIColor.blackColor()
                button.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                button.layer.borderWidth=0.7
                button.layer.cornerRadius=2
                
                courseDetailPopover!.view.addSubview(button)
            }
            
            courseDetailPopover!.view.addSubview(codeLabel)
            courseDetailPopover!.view.addSubview(titleLabel)
            courseDetailPopover!.view.addSubview(sectionLabel)
            courseDetailPopover!.view.addSubview(unitsLabel)
            courseDetailPopover!.view.addSubview(hoursLabel)
            courseDetailPopover!.view.addSubview(daysLabel)
            courseDetailPopover!.view.addSubview(instructorLabel)
            courseDetailPopover!.view.addSubview(locationLabel)
            
            // pop!
            self.presentViewController(courseDetailPopover!, animated: true, completion: nil)
        }
    }
    
    func createLabel(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, _ text: String) -> UILabel {
        var label: UILabel = UILabel(frame: CGRectMake(x, y, width, height))
        label.text = text
        label.font = UIFont(name: "Optima", size: 13)
        label.lineBreakMode = NSLineBreakMode.ByCharWrapping
        label.numberOfLines = 0
        return label
    }
    
    func removeTappedSubSection() {
        if let sub = tappedSubSection {
            if sub.type == self.SCHEDULED_COURSE_TYPE {
                self.removeCourseFromCourseBin(self.getIndex(self.scheduledCourses, item: sub.section!))
            } else {
                self.removeRegisteredCourse(self.getIndex(self.registeredCourses, item: sub.section!))
            }
        }
        
        self.cancelPopover()

    }
    
    func getIndex(arr: [Section], item: Section) -> Int {
        for var i = 0; i < arr.count; ++i {
            if arr[i].id == item.id {
                return i
            }
        }
        return -1
    }
    
    func cancelPopover() {
        courseDetailPopover?.dismissViewControllerAnimated(true, completion: nil)
        courseDetailPopover = nil
        tappedSubSection = nil
    }
    
    func loadData() {
        registeredCourses = DataAccess.retrieveRegisteredCourse( term: term! )!
        scheduledCourses = DataAccess.retrieveCoursebin( term: term! )!
    }

    func setView(){
        let scrollView = self.view.subviews[0] as! UIScrollView
        
        for section in registeredCourses{
            if section.day == nil || section.beginTime.rangeOfString(":") == nil{
                continue
            }
            for character in section.day!{
                sectionDictionary.updateValue(REGISTERED_COURSE_TYPE, forKey: SubSection(section: section, day: character, type: REGISTERED_COURSE_TYPE, instance: self))
            }
        }
        for section in scheduledCourses{
            if section.day == nil || section.beginTime.rangeOfString(":") == nil{
                continue
            }
            for character in section.day!{
                sectionDictionary.updateValue(SCHEDULED_COURSE_TYPE, forKey: SubSection(section: section, day: character, type: SCHEDULED_COURSE_TYPE, instance: self))
            }
        }
        
        revealConflict()
        let gridHeight = HOUR_HEIGHT * 17
        
        for i in 6...23{
            var height:CGFloat = 10
            var hourLabel = UILabel(frame: CGRectMake(0.0, CGFloat(i-6)*HOUR_HEIGHT + HEAD_HEIGHT - height/2, HOURE_WIDTH, height))
            hourLabel.text = String(i) + ":00"
            hourLabel.textAlignment = NSTextAlignment.Right
            hourLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
            self.view.subviews[0].viewWithTag(HOUR_TAG)?.addSubview(hourLabel)
        }
        
        for i in 12...46{
            var line = UIView(frame: CGRectMake(0, CGFloat(i-12)/2*HOUR_HEIGHT + HEAD_HEIGHT, GRID_WIDTH, 1))
            line.backgroundColor = UIColor.UIColorFromRGB(0xE0E0E0)
            self.view.subviews[0].viewWithTag(GRID_TAG)?.addSubview(line)
        }

        for i in 0...7{
            let x:CGFloat = (VIEW_WIDTH+1)*CGFloat(i)
            var line = UIView(frame: CGRectMake(x, HEAD_HEIGHT, 1, gridHeight))
            line.backgroundColor = UIColor.UIColorFromRGB(0xE0E0E0)
            self.view.subviews[0].viewWithTag(GRID_TAG)?.addSubview(line)
            
            if ( i < 7 ){
                var dayLabel = UILabel(frame: CGRectMake(x, 0, VIEW_WIDTH, HEAD_HEIGHT))
                dayLabel.text = dayText[i]
                dayLabel.textColor = UIColor.UIColorFromRGB(0x980000)
                dayLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
                dayLabel.textAlignment = NSTextAlignment.Center
                self.view.subviews[0].viewWithTag(GRID_TAG)?.addSubview(dayLabel)
            }
            
        }
        
        for (subsection: SubSection, type: Int) in sectionDictionary{
            
            subsection.backgroundColor = colorDictionary[type]
            
            var range = subsection.section!.course.sisId.rangeOfString("-")
            var height:CGFloat = subsection.frame.height
            var courseCode1 = UILabel(frame: CGRectMake(0.0, height/2-12, 40.0, 12.0))
            courseCode1.text = subsection.section!.course.sisId.substringToIndex(Range(range!).startIndex)
            courseCode1.font = UIFont(name: courseCode1.font.fontName, size: 11)
            courseCode1.textAlignment = NSTextAlignment.Center
            
            var courseCode2 = UILabel(frame: CGRectMake(0.0, height/2, 40.0, 12.0))
            courseCode2.text = subsection.section!.course.sisId.substringFromIndex(advance(Range(range!).startIndex, 1))
            courseCode2.font = UIFont(name: courseCode2.font.fontName, size: 11)
            courseCode2.textAlignment = NSTextAlignment.Center
            
            if type == CONFLICT_COURSE_TYPE{
                subsection.alpha = CONFLICT_ALPHA
                courseCode1.textColor = UIColor.whiteColor()
                courseCode2.textColor = UIColor.whiteColor()
            }
            
            subsection.addSubview(courseCode1)
            subsection.addSubview(courseCode2)
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
            subsection.addGestureRecognizer(tapRecognizer)
            
            var parentView: UIView = self.view.viewWithTag(0)!.viewWithTag(COURSE_TAG)!
            parentView.addSubview(subsection)
        }
    }
    
    func getFrame( section: Section, day: Character )-> CGRect{
        var dayIndex = dayDictionary[day]!
        var hour1 = section.beginTime.substringToIndex(advance(section.beginTime.startIndex, 2)).toInt()!
        var minute1 = section.beginTime.substringFromIndex(advance(section.beginTime.endIndex, -2)).toInt()!
        var hour2 = section.endTime.substringToIndex(advance(section.endTime.startIndex, 2)).toInt()!
        var minute2 = section.endTime.substringFromIndex(advance(section.endTime.endIndex, -2)).toInt()!
        
        var height = CGFloat((hour2-hour1)*60+minute2-minute1)*HOUR_HEIGHT/60
        var x = CGFloat(dayIndex-1)*(VIEW_WIDTH+1) + 1
        var y = CGFloat((hour1-6)*60 + minute1)*HOUR_HEIGHT/60 + HEAD_HEIGHT
        return CGRectMake(x , y, VIEW_WIDTH, height)
    }

    
    func reloadData(){
        loadData()
        clearView()
        self.sectionDictionary.removeAll(keepCapacity: true)
        setView()
        refreshControl?.endRefreshing()
    }
    
    func removeRegisteredCourse(index: Int) {
        self.registeredCourses.removeAtIndex(index)
            
        DataAccess.persistRegisteredCourse(registeredCourses, term: term!)
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.reloadData()
//        })
        
        reloadMyCourseData()
    }

    
    func removeCourseFromCourseBin(index: Int) {
        
        scheduledCourses.removeAtIndex(index)
        
        DataAccess.persistCoursebin(scheduledCourses, term: term!)
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.reloadData()
        //})
        reloadMyCourseData()
    }
    
    func reloadMyCourseData(){
        var n = navigationController!.viewControllers.count
        let controller = self.navigationController?.viewControllers[n-2] as! MyCourseViewController
        controller.reloadData()
    }
    
    func clearView(){
        for view in self.view.subviews[0].viewWithTag(HOUR_TAG)!.subviews {
            let v = view as! UIView
            v.removeFromSuperview()
        }
        for view in self.view.subviews[0].viewWithTag(GRID_TAG)!.subviews{
            let v = view as! UIView
            v.removeFromSuperview()
        }
        for view in self.view.subviews[0].viewWithTag(COURSE_TAG)!.subviews{
            let v = view as! UIView
            v.removeFromSuperview()
        }

    }

    

}

class SubSection: UIView, Hashable{
    var section: Section?
    var day: Character?
    var type: Int?

    override var hashValue:Int{
        return section!.id.hashValue^day!.hashValue
    }
    
    init( section: Section, day: Character, type: Int, instance : CalendarViewController ){
        self.section = section
        self.day = day
        self.type = type
        super.init(frame: instance.getFrame(section, day: day))
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

func ==(l:SubSection, r:SubSection)-> Bool{
    return l.section!.id == r.section!.id && l.day == r.day
}
