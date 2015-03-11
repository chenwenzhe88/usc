//
//  CourseDetailCell.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/17/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import UIKit

class CourseDetailCell: UITableViewCell {

    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseUnits: UILabel!
    @IBOutlet weak var courseType: UILabel!
    @IBOutlet weak var sectionCode: UILabel!
    @IBOutlet weak var instructorName: UILabel!
    @IBOutlet weak var classNum: UILabel!
    @IBOutlet weak var numOfWaits: UILabel!
    @IBOutlet weak var numOfRegs: UILabel!
    @IBOutlet weak var roomNum: UILabel!
    @IBOutlet weak var classDays: UILabel!
    @IBOutlet weak var classHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
