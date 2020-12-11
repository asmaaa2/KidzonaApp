//
//  ProfileViewController.swift
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
import SDWebImage
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var myProfile: UIView!
    @IBOutlet weak var activities: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var events: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            myProfile.alpha = 1
            activities.alpha = 0
            events.alpha = 0
        } else if sender.selectedSegmentIndex == 1{
            myProfile.alpha = 0
            activities.alpha = 1
            events.alpha = 0
        } else{
            myProfile.alpha = 0
            activities.alpha = 0
            events.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myProfile.alpha = 1
        activities.alpha = 0
        events.alpha = 0
        //myProfile.reloadInputViews()
        retrieveData()
    }
    
    var userData: UserData?

    
     func retrieveData() {
    
      let ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {return}
        ref.child("User").child(userId).child("Information").observeSingleEvent(of: .value) { (snapshot) in
            
            
            guard let dic = snapshot.value as? [String: Any] else {return}
            
            let user = UserData(uid: userId, dictionary: dic)
            self.userName.text = user.fullName
            self.userData = user
          
            
            //let photoURL = URL(String: (userData!.userImage))
            if (self.userData?.userImage != ""){
            let photoURL = URL(string: (self.userData?.userImage)!)
            print("UserImage : \(photoURL)")
            
            if let url = photoURL as? URL{
                KingfisherManager.shared.retrieveImage(with: url as! Resource, options: nil, progressBlock: nil){ (image , error, cache, coursename) in
                    
                    print("image came )")
                    self.userImage.image = image
                    self.userImage.kf.indicatorType = .activity
                }
            }
            }
            else {
                self.userImage.image = UIImage(named: "profile")
            }
          
//
            
            ////////////
            
//            let url = URL(string: (myCourse!.courseImage)!)
//            if let url = url as? URL{
//                KingfisherManager.shared.retrieveImage(with: url as! Resource, options: nil, progressBlock: nil){ (image , error, cache, coursename) in
//                    self.courseImg.image = image
//                    self.courseImg.kf.indicatorType = .activity
//                }
//            }
            /////////////////
            
//            if let photoURL = self.userData?.userImage{
//                 print("PhotoUrl: \(photoURL)")
//                //Download Photo
//                URLSession.shared.dataTask(with: URL(string: photoURL)!) { (data, response, err) in
//                    if let err = err {
//                        print("Failed to download user image", err)
//                        return
//                    }
//                    if let data = data , let image = UIImage(data: data){
//                        DispatchQueue.main.async{
//                            self.userImage.image = image
//                        }
//                    }
//                    }.resume()
//            }
         
        }
    }



    
    
}
