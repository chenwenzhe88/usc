//
//  Department.swift
//  WebRegistration
//
//  Created by ADMIN on 2/16/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

class Department {
    var code: String
    var description: String
    var school: School
    init( code: String, description: String, school: School ){
        self.code = code;
        self.description = description;
        self.school = school;
    }
    
    
}