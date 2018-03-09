//
//  CourseTableViewCell.swift
//  Organizador De Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    @IBOutlet weak var lbCourseName: UILabel!
    
    var courseName: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
