//
//  Review.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 6/13/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import Foundation

class AcademyReview {
    var userName : String
    var date : String
    var rating : Double
    
    init(userName : String, date : String, rating : Double){
        self.userName = userName
        self.date = date
        self.rating = rating
    }
}
