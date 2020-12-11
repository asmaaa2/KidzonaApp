//
//  ProfileDetailsViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 5/25/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var birthDateLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var userEmailDetails: UILabel!
    
     var userData = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editBtn.layer.cornerRadius = 15
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
    }
    
   
    
    fileprivate func retrieveData() {
        let ref :  DatabaseReference!
        ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        ref.child("User").child(userId).child("Information").observeSingleEvent(of: .value) { (snapshot) in
            
            
            guard let value = snapshot.value as? [String: Any] else {return}
            print(("Values : \(value)"))
            let dataUser = UserData(uid: userId, dictionary: value)
            self.userData.append(dataUser)
           guard let userBirthDate = self.userData.first?.birthDate else {
            self.birthDateLbl.text = ""
            return
        }
            self.birthDateLbl.text = userBirthDate
           
            guard let gender = self.userData.first?.gender else {return}
            self.genderLbl.text = gender
          guard let useremail = self.userData.first?.email else {return}
            self.userEmailDetails.text = useremail
            
        }
        
    }

  

}
