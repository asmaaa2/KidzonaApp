//
//  EventCellCollectionViewCell.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 5/29/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

class EventCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var eventImageInEventCollection: UIImageView!
    
    
    @IBOutlet weak var eventNameInEventCollection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventImageInEventCollection.layer.cornerRadius = 15
    }
    
    
}
