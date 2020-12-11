//
//  UserDataprofile.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/2/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import Foundation

class UserData {
    var fullName: String
    var email : String
    var userImage : String
    var uid: String
    var birthDate : String
    var gender: String
    
    init(uid: String, dictionary: [String: Any]){
        self.fullName = dictionary["UserName"] as! String
        self.email = dictionary["userEmail"] as! String
        self.userImage = dictionary["profileImage"] as? String ?? ""
        self.birthDate = dictionary["birthDate"] as? String ?? ""
        self.gender = dictionary["gender"] as? String ?? ""
        self.uid = uid
    }
}
