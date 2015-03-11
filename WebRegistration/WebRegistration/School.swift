//
//  Department.swift
//  WebRegistration
//
//  Created by ADMIN on 2/16/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

public class School{
    var code: String
    var description: String
    var departmentList: [Department] = []
    var hasDepartment = false
    
    init(code:String, description:String){
        self.code = code
        self.description = description
    }

    func parseDepartment( data:NSData ){
        let json = JSON(data:data)
        
        //if json[0]["SOC_SCHOOL_CODE"].string != self.code{
        //    return
        //}
        var departmentJSON: JSON = json[0]["SOC_DEPARTMENT_CODE"]
        var departmentList: [Department] = []
        
        for ( index: String, subJson: JSON ) in departmentJSON{
            let newDepartment = Department( code: subJson["SOC_DEPARTMENT_CODE"].string!, description: subJson["SOC_DEPARTMENT_DESCRIPTION"].string!, school: self) as Department
            departmentList.append(newDepartment)
        }
        sort(&departmentList){$0.description < $1.description}
        self.departmentList = departmentList
        hasDepartment = true
    }
    
    class func parseAllSchool( data: NSData ) -> [School]{
        let json = JSON(data:data)
        
        var schoolList: [School] = []
        for ( index: String, subJson: JSON) in json{
            let newSchool = School( code: subJson["SOC_SCHOOL_CODE"].string!, description: subJson["SOC_SCHOOL_DESCRIPTION"].string!) as School
            schoolList.append(newSchool)
            //println("school: code: \(newSchool.code), description: \(newSchool.description)")
        }
        sort(&schoolList){$0.description < $1.description}
        
        return schoolList
        
    }
    
    
}