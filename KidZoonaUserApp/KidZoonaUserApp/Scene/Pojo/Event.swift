//
//  Event.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 6/9/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import Foundation
class Event {
    var name: String
    var date: String
    var time: String
    var price: String
    var descrption: String
    var image: String
    var coach: String
    var location: String
    var availableSeats: String
    
    init(dictionary: [String: Any])
    {
        self.name = (dictionary["name"] as? String) ?? ""
        self.date = dictionary["date"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? ""
        self.price = dictionary["price"] as? String ?? ""
        self.descrption = dictionary["description"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""
        self.coach = dictionary["coach"]  as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.availableSeats = dictionary["availableSeats"] as? String ?? ""
    }
    
}
