//
//  AcademyTableViewCell.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/2/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class AcademyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: DesignCourseList!
    
    @IBOutlet weak var academyImage: UIImageView!
    @IBOutlet weak var academyRateView: CosmosView!
    @IBOutlet weak var academyName: UILabel!
    
    var academyObj : Academy?{
        didSet{
            academyName.text = academyObj?.name
            
            academyRateView.settings.updateOnTouch = false
            academyRateView.settings.totalStars = 5
            academyRateView.settings.fillMode = .precise
            academyRateView.rating = 2.5 // will updates with overAll rate
            
            let url = URL(string: (academyObj?.image)!)
            if let imgUrl = url as? URL{
                KingfisherManager.shared.retrieveImage(with: imgUrl as! Resource, options: nil, progressBlock: nil) { (image, error, cache, academyImage) in
                    self.academyImage.image = image
                    self.academyImage.kf.indicatorType = .activity
                }
            }
            else {
                academyImage.image = UIImage(named: "noimage")
                
            }
        }
    }
    
//    var rate : String?
//    var cosmosVar : CosmosView!{
//        didSet{
//            cosmosVar.settings.updateOnTouch = false
//            cosmosVar.settings.totalStars = 5
//            cosmosVar.settings.fillMode = .precise
//            cosmosVar.rating = 2.5
//            academyRateView = cosmosVar
//        }
//    }
    

}

extension AcademyTableViewCell {
//
////    func setUpCosmosUIView(){
////        rateView.settings.fillMode = .full
////        rateView.didTouchCosmos = {rating in
////            print("rate is\(rating)")
////            self.rate = "\(rating)"
////        }
////    }
//
//    func setUpCosmosView(defultRateValue : Double){
//        academyRateView.settings.updateOnTouch = false
//        academyRateView.settings.totalStars = 5
//        academyRateView.settings.fillMode = .precise
//        academyRateView.rating = defultRateValue
//    }
    
    
    
    func calcAvgRatesForAcadmies(rates : [Double] ) -> Double{
        let sumArr = rates.reduce(0 , +)
        let avgRates = Double(sumArr) / Double(rates.count)
        
        return avgRates
    }
}
