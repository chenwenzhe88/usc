//
//  ScheduleViewCell.swift
//  WebRegistration
//
//  Created by Amelech on 2/20/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {

    @IBOutlet weak var courseLocationBG: UIView!
    @IBOutlet weak var courseLocation: UILabel!
    @IBOutlet weak var courseTime: UILabel!
    @IBOutlet weak var courseID: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseInstructor: UILabel!
    @IBOutlet weak var courseSLine: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
