//
//  ImageTableViewCell.swift
//  ProyectoFinal - Organizador de Apuntes
//
//  Created by Angel Seiji Morimoto Burgos on 3/28/18.
//  Copyright © 2018 itesm. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgName: UILabel!
    @IBOutlet weak var btDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
