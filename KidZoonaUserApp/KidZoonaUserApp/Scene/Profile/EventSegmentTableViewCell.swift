//
//  EventSegmentTableViewCell.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/6/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

class EventSegmentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var academyName: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
