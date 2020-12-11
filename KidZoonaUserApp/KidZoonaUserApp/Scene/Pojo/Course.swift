//
//  Course.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 6/7/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import Foundation

class Course {
    var id : String
    var name : String
    var availablePlace : String
    var date : String
    var instructor : String
    var image : String
    var description : String
    var offer : String
    var location : String
    var price : String
    var time : String
    var type : String
//    var rate : String
    
    init(dictionary: [String: Any]){
        self.name = dictionary["courseName"] as? String ?? ""
        self.availablePlace = dictionary["courseAvailablePlace"] as? String ?? ""
        self.date = dictionary["courseDate"] as? String ?? ""
        self.instructor = dictionary["courseInstructor"] as? String ?? ""
        self.image = dictionary["courseImage"] as? String ?? ""
        self.offer = dictionary["courseOffer"] as? String ?? ""
        self.description = dictionary["courseDescription"] as? String ?? ""
        self.id = dictionary["key"] as? String ?? ""
        self.location = dictionary["coursePlace"] as? String ?? ""
        self.price  = dictionary["coursePrice"] as? String ?? ""
        self.time = dictionary["courseTime"] as? String ?? ""
        self.type = dictionary["courseType"] as? String ?? ""
//        self.rate = dictionary["rate"] as! String
    }
}
