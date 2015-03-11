//
//  Term.swift
//  WebRegistration
//
//  Created by ADMIN on 2/17/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation

class Term {
    var code:String
    var description:String
    // add more if needed

    init(code: String, description: String){
        self.code = code
        self.description = description
    }
    
    class func parseAllTerm( data: NSData ) -> [Term]{
        var json = JSON(data:data)
        
        var termList:[Term] = []
        for (index: String, subJson: JSON) in json{
            let newTerm = Term(code: subJson["TERM_CODE"].string!, description: subJson["DESCRIPTION"].string!)
            termList.append(newTerm)
        }
        
        return termList
    }
    
}