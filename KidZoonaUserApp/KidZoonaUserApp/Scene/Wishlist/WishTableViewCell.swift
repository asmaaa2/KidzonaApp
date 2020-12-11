//
//  WishTableViewCell.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/2/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import Kingfisher

class WishTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var cardDesign: DesignCourseList!
    @IBOutlet weak var courseDate: UILabel!
    @IBOutlet weak var courseImg: UIImageView!
    @IBOutlet weak var academyName: UILabel! // cannot get it
//    @IBOutlet weak var favBtn: RoundedBtn!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    
    var courseObj : Course?{
        didSet{
            courseName.text = courseObj?.name
            courseDate.text = courseObj?.date
            
            rateView.settings.updateOnTouch = false
            rateView.settings.totalStars = 5
            rateView.settings.fillMode = .precise
            rateView.rating = 2.5 // will updates with overAll rate from review Branch
            
            let url = URL(string: (courseObj?.image)!)
            if let imgUrl = url as? URL{
                KingfisherManager.shared.retrieveImage(with: imgUrl as! Resource, options: nil, progressBlock: nil) { (image, error, cache, courseImage) in
                    self.courseImg.image = image
                    self.courseImg.kf.indicatorType = .activity
                }
            }   else {
                courseImg.image = UIImage(named: "noimage")
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension WishTableViewCell{

    
}
