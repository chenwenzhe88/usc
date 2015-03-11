//
//  SettingsTableViewController.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/14/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var prev_switch: UISwitch!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var name: UILabel!
    var profile:Profile?
    var Switch:Boolean?
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text="Edwin"
        major.text="Computer Science"
        email.text="wenzhech@usc.edu"
        if profile?.name != nil{
            name.text=profile?.name
        }
        if profile?.major != nil{
            major.text=profile?.major
        }
        if profile?.email != nil{
            email.text=profile?.email
        }
        prev_switch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let isEnableSchedulePreview: Bool = dict?.objectForKey("EnableSchedulePreview") as! Bool
        prev_switch.on = isEnableSchedulePreview
    }
    
    
    @IBAction func clickLogout(sender: AnyObject) {
        self.navigationController?.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        header.textLabel.textColor = Constants.tableViewHeaderTextColor
        header.contentView.backgroundColor = Constants.tableViewHeaderBackgroundColor
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Profile Setting"
        }
        else {
            return "App Setting"
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section < 2{
            return Constants.tableViewHeaderHeight
        }
        return 0
    }
    
    func stateChanged(switchState: UISwitch) {
    
        var path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        var dict = NSMutableDictionary(contentsOfFile: path!)
        if switchState.on {
            dict?.setValue(true, forKey: "EnableSchedulePreview")
            dict?.writeToFile(path!, atomically: true)
        } else {
            dict?.setValue(false, forKey: "EnableSchedulePreview")
            dict?.writeToFile(path!, atomically: true)
        }
    }
}
