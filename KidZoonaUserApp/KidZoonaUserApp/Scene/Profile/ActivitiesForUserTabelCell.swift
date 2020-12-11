//
//  ActivitiesForUserTabelCell.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 6/2/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

class ActivitiesForUserTabelCell: UITableViewCell {

    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var academyName: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
