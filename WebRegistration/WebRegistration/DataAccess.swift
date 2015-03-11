//
//  DataAccess.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/19/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

class DataAccess {
    class func retrieveRegisteredCourse(term: Term = Term(code: "", description: "")) -> [Section]? {
//        var courses: [Section]?
//        
//        let path = NSBundle.mainBundle().pathForResource("registeredCourses", ofType: "txt")
//        
//        if path == nil {
//            NSLog("DataAccessError: %@", "file registereddCourse.txt not found")
//        } else {
//            var data = NSData(contentsOfFile: path!)
//            courses = Section.parseSectionList(data!)
//        }
//        return courses
        let data = getDataFromDirectory("registeredCourses\(term.code).txt")
        if data != nil{
            return Section.parseSectionList(data!)
        }
        return []
    }
    
    class func persistRegisteredCourse( sections: [Section], term: Term = Term(code: "", description: "") ) {
        var str: String = "["
        if ( sections.count > 0 ){
            for i in 0...sections.count-1{
                if ( i > 0 ){
                    str += ","
                }
                str += sections[i].rawData!
            }
        }
        str += "]"
        writeDataToDirectory("registeredCourses\(term.code).txt", data: str)
    }

    class func retrieveCoursebin(term: Term = Term(code: "", description: "")) -> [Section]? {
        
        let data = getDataFromDirectory("courseBin\(term.code).txt")
        if data != nil{
            return Section.parseSectionList(data!)
        }
        return []
    }
    
    class func persistCoursebin( sections: [Section], term: Term = Term(code: "", description: "")) {
        var str: String = "["
        if sections.count > 0{
            for i in 0...sections.count-1{
                if ( i > 0 ){
                    str += ","
                }
                str += sections[i].rawData!
            }
        }
        str += "]"
        writeDataToDirectory("courseBin\(term.code).txt", data: str)
    }
    
    class func retrieveTerms() -> [Term]? {
        var data = getDataFromBundle("terms")
        //var data = getDataFromServer("http://petri.esd.usc.edu/socAPI/Terms")
        if data != nil{
            return Term.parseAllTerm(data!)
        }
        return []
    }
    
    class func retrieveSchools()->[School]?{
        var data = getDataFromBundle("schools")
        //var data = getDataFromServer("http://petri.esd.usc.edu/socAPI/Schools")
        if data != nil{
            return School.parseAllSchool(data!)
        }
        return []
    }
    
    class func retrieveDepartments( school: School? ){
        //var data = getDataFromBundle("departments")
        var data = getDataFromServer("http://petri.esd.usc.edu/socAPI/Schools/\(school!.code)")
        if data != nil{
            school?.parseDepartment(data!)
        }
    }
    
    class func retrieveCourseInDepartment( department: Department, term: Term = Term(code: "", description: "") )->[Course]?{
        //var data = getDataFromBundle("courses")
        var data = getDataFromServer("http://petri.esd.usc.edu/socAPI/Courses/20151/\(department.code)")
        if data != nil{
            return Course.parseCourseList(data!)
        }
        return []
    }
    
    class func retrieveSections( course : Course, term: Term = Term(code: "", description: "") ){
        //var data = getDataFromBundle("sections")
        var data = getDataFromServer("http://petri.esd.usc.edu/socAPI/Courses/20151/\(course.id)")
        if data != nil{
            course.parseSection(data!)
            course.rawData = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
        }
    }
    
    class func writeDataToDirectory( fileName: String, data: String ){
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        var path: String?
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            path = dir.stringByAppendingPathComponent(fileName)
        }
        if path == nil{
            return
        }
        let manager = NSFileManager.defaultManager()
        if (!manager.fileExistsAtPath(path!)) {
            manager.createFileAtPath(path!, contents: nil, attributes: nil)
        }
        data.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    class func getDataFromBundle( fileName: String, type: String = "txt" )->NSData?{

        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: type)
        if path == nil {
            return nil
        }
        return NSData(contentsOfFile: path!)
    }
    
    class func getDataFromServer( urlString: String )->NSData?{
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        return data
    }
    
    class func getDataFromDirectory( fileName: String )->NSData?{
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
        var path: String?
        if ((dirs) != nil) {
            let dir = dirs![0]; //documents directory
            path = dir.stringByAppendingPathComponent(fileName)
        }
        if path == nil{
            return nil
        }
        let manager = NSFileManager.defaultManager()
        if (!manager.fileExistsAtPath(path!)) {
            //manager.createFileAtPath(path!, contents: nil, attributes: nil)
            return nil
        }
        return NSData(contentsOfFile: path!)
    }
}