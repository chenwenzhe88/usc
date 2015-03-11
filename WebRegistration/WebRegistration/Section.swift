//
//  Section.swift
//  WebRegistration
//
//  Created by ADMIN on 2/17/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

class Section {
    var id: Int
    var section: String
    var session: String
    var day: String?
    var location: String
    var seats: Int
    var registered: Int
    var instructor: String?
    var beginTime: String
    var endTime: String
    var course: Course
    var type: String?
    var rawData: String?
    
    init( id: Int, section: String?, session: String?, day: String?, location: String?, seats: Int, registered: Int, instructor: String?, beginTime: String?, endTime: String?, type: String?, course: Course ){
        self.id = id
        
        if section==nil{
            self.section = ""
        }
        else {
            self.section = section!
        }
        if session == nil{
            self.session = ""
        }
        else {
            self.session = session!
        }
        self.day = day
        if location != nil{
            self.location = location!
        }
        else {
            self.location = ""
        }
        self.seats = seats
        self.registered = registered
        self.instructor = instructor
        
        if beginTime==nil{
            self.beginTime = ""
        }
        else {
            self.beginTime = beginTime!
        }
        if endTime==nil{
            self.endTime = ""
        }
        else {
            self.endTime = endTime!
        }

        self.type = type
        self.course = course
    }
    
    class func parseSection( data: NSData ) -> Section{
        var json = JSON(data:data)
        var sectionList:[Section] = []
        var subJson = json[0]
        var registered: Int = 0
        if (subJson["REGISTERED"].double != nil){
            registered = Int(subJson["REGISTERED"].doubleValue)
        }

        var course: Course = Course( id: subJson["COURSE_ID"].intValue, sisId: subJson["SIS_COURSE_ID"].string!, title: subJson["V_SOC_COURSE"]["TITLE"].string!, maxUnits: subJson["MAX_UNITS"].doubleValue, minUnits: subJson["MIN_UNITS"].doubleValue, description: nil )
        
        let newSection = Section( id: subJson["SECTION_ID"].intValue, section: subJson["SECTION"].string, session: subJson["SESSION"].string , day: subJson["DAY"].string, location: subJson["LOCATION"].string, seats: subJson["SEATS"].intValue, registered: registered , instructor: subJson["INSTRUCTOR"].string, beginTime: subJson["BEGIN_TIME"].string, endTime: subJson["END_TIME"].string, type: subJson["TYPE"].string, course: course ) as Section

        newSection.rawData = subJson.rawString()
        return newSection
    }
    
    class func parseSectionList( data: NSData ) -> [Section] {
        var json = JSON(data:data)
        var sectionList:[Section] = []
        
        for (index: String, subJson: JSON) in json {
            var registered: Int = 0
            if (subJson["REGISTERED"].double != nil){
                registered = Int(subJson["REGISTERED"].doubleValue)
            }

            var course: Course = Course( id: subJson["COURSE_ID"].intValue, sisId: subJson["SIS_COURSE_ID"].string!, title: subJson["V_SOC_COURSE"]["TITLE"].string!, maxUnits: subJson["MAX_UNITS"].doubleValue, minUnits: subJson["MIN_UNITS"].doubleValue, description: nil )
            
            let newSection = Section( id: subJson["SECTION_ID"].intValue, section: subJson["SECTION"].string, session: subJson["SESSION"].string , day: subJson["DAY"].string, location: subJson["LOCATION"].string, seats: subJson["SEATS"].intValue, registered: registered , instructor: subJson["INSTRUCTOR"].string, beginTime: subJson["BEGIN_TIME"].string, endTime: subJson["END_TIME"].string, type: subJson["TYPE"].string, course: course ) as Section

            newSection.rawData = subJson.rawString()
            sectionList.append(newSection)
        }
        return sectionList
    }
    
}