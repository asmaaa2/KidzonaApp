//
//  CourseListCell.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 6/4/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class CourseListCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var coursePriceLabel: UILabel!
    @IBOutlet weak var cosmosRateView: CosmosView!
    @IBOutlet weak var courseImage: UIImageView!
    
    var courseObj : Course?{
        didSet{
            courseNameLabel.text = courseObj?.name
            coursePriceLabel.text = courseObj?.price
            
            cosmosRateView.settings.updateOnTouch = false
            cosmosRateView.settings.totalStars = 5
            cosmosRateView.settings.fillMode = .precise
            cosmosRateView.rating = 2.5 // will updates with overAll rate from review Branch
            
            let url = URL(string: (courseObj?.image)!)
            if let imgUrl = url as? URL{
                KingfisherManager.shared.retrieveImage(with: imgUrl as! Resource, options: nil, progressBlock: nil) { (image, error, cache, courseImage) in
                    self.courseImage.image = image
                    self.courseImage.kf.indicatorType = .activity
                }
            }
            else {
                courseImage.image = UIImage(named: "noImage")
            }
        }
    }
    
//    var cosmosVar : CosmosView!{
//        didSet{
//            cosmosVar.settings.updateOnTouch = false
//            cosmosVar.settings.totalStars = 5
//            cosmosVar.settings.fillMode = .precise
//            cosmosVar.rating = 2.5
//            cosmosRateView = cosmosVar
//        }
//    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        setUpCosmosView(defultRateValue: 2.5)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
//
extension CourseListCell{
//    
////    func setUpCosmosView(defultRateValue : Double){
////        cosmosRateView.settings.updateOnTouch = false
////        cosmosRateView.settings.totalStars = 5
////        cosmosRateView.settings.fillMode = .precise
////        cosmosRateView.rating = defultRateValue
////    }
    
    
    
    func calcAvgRatesForAcadmies(rates : [Double] ) -> Double{
        let sumArr = rates.reduce(0 , +)
        let avgRates = Double(sumArr) / Double(rates.count)
        
        return avgRates
    }
}

