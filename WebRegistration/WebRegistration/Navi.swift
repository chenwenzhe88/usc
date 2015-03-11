//
//  Navi.swift
//  WebRegistration
//
//  Created by ADMIN on 2/26/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class Navi:UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.tag = 123
        print("navi: ")
        println(self)
    }
}
