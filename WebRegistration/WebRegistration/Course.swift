//
//  Course.swift
//  WebRegistration
//
//  Created by ADMIN on 2/16/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

class Course {
    var id: Int
    var sisId: String
    var title: String
    var maxUnits: Double
    var minUnits: Double
    var totalMaxUnits: Double?
    var description: String?
    //var divisityFlag: String
    //var term: Term
    var sectionList:[Section]
    var hasSection:Bool = false
    var rawData: String?
    
    init( id: Int, sisId: String, title: String, maxUnits: Double, minUnits: Double, description: String? ){
        self.id = id
        self.sisId = sisId
        self.title = title
        self.maxUnits = maxUnits
        self.minUnits = minUnits
        self.description = description
        sectionList = []
    }
    
    func parseSection( data: NSData ){
        var json = JSON(data:data)
        var sectionList:[Section] = []
        for ( index: String, subJson: JSON ) in json["V_SOC_SECTION"]{
            var registered: Int = 0
            if ( subJson["REGISTERED"].double != nil ){
               registered = Int(subJson["REGISTERED"].doubleValue)
            }
            
            let newSection = Section( id: subJson["SECTION_ID"].intValue, section: subJson["SECTION"].string, session: subJson["SESSION"].string , day: subJson["DAY"].string, location: subJson["LOCATION"].string, seats: subJson["SEATS"].intValue, registered: registered , instructor: subJson["INSTRUCTOR"].string, beginTime: subJson["BEGIN_TIME"].string, endTime: subJson["END_TIME"].string, type: subJson["TYPE"].string, course: self ) as Section
            newSection.rawData = subJson.rawString()
            sectionList.append(newSection)
        }
        
        self.sectionList = sectionList
    }
    
    class func parseCourseList( data: NSData )->[Course]{
        var json = JSON(data:data)
        var courseList:[Course] = []
        for ( index: String, subJson: JSON ) in json{
            let newCourse = Course(id: subJson["COURSE_ID"].intValue, sisId: subJson["SIS_COURSE_ID"].string!, title: subJson["TITLE"].string!, maxUnits: subJson["MAX_UNITS"].doubleValue, minUnits: subJson["MIN_UNITS"].doubleValue, description: subJson["DESCRIPTION"].string) as Course
            
            newCourse.rawData = subJson.rawString()
            courseList.append(newCourse)
        }
        
        return courseList
    }
    
}