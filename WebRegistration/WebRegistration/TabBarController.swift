//
//  TabBarController.swift
//  WebRegistration
//
//  Created by ADMIN on 2/26/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let navigation = viewController as! UINavigationController
        for controller in navigation.viewControllers{
            if let con = controller as? MyCourseViewController{
                con.reloadData()
            }
            else if let con = controller as? CalendarViewController{
                con.reloadData()
            }
            else if let con = controller as? RegistrationTableViewController{
                
            }
        }
    }
}
