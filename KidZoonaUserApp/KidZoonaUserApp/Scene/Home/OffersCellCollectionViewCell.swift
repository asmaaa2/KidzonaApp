//
//  OffersCellCollectionViewCell.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 5/29/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class OffersCellCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var offerImageInOffersCollection: UIImageView!
    
    
    @IBOutlet weak var courseNameInOffersCollection: UILabel!
    
    
    @IBOutlet weak var courseDiscountInOffersCollection: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        offerImageInOffersCollection.layer.cornerRadius = 15
    }
    
    
    
}
