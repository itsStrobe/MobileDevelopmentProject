//
//  CustomTableViewCell.swift
//  Organizador De Apuntes
//
//  Created by Alumno on 3/9/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    
    var name: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red: 0, green: 114, blue: 187, alpha: 100)
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
