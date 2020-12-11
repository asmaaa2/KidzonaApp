//
//  EventViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 5/22/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher


class EventViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var eventDirectionOnMap: UIButton!
    @IBOutlet weak var eventCost: UILabel!
    @IBOutlet weak var eventRegisteredPeople: UILabel!
    
    @IBOutlet weak var availablePlacesInEvent: UILabel!
    
    @IBOutlet weak var desciptionTextOfEvent: UITextView!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    var name: String = ""
    var date: String = ""
    var time: String = ""
    var price: String = ""
    var descrption: String = ""
    var image: String = ""
    var coach: String = ""
    var location: String = ""
    var availableSeats: String = ""
    var eventKey: String = ""
    var allKeysRegisterEvents = [String]()
    var code : String = ""

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn.layer.cornerRadius = 15
        registerBtn.layer.shadowOpacity = 0.25
        registerBtn.layer.shadowRadius = 5
        registerBtn.layer.shadowOffset = CGSize(width: 0, height: 10)
        getAllKeyRegistered()
        setupView()
    }
    
    fileprivate func setupView(){
        
        let imageUrl = URL(string: image)
        if let url = imageUrl{
            KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil){ (image , error, cache, coursename) in
                self.eventImage.image = image
                self.eventImage.kf.indicatorType = .activity
                
            }
        }
        
        eventName.text = name
        eventDate.text = date
        eventTime.text = time
        eventAddress.text = location
        availablePlacesInEvent.text = availableSeats
        eventCost.text = price
        desciptionTextOfEvent.text = descrption
    }
    
    
    fileprivate func getAllKeyRegistered(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("User").child(uid).child("enrollment").child("event").observe(.value, with: { (snapshot) in
            
            snapshot.children.forEach { (data) in
                let snap = data as! DataSnapshot
                guard let dict = snap.value as? [String: Any] else {return}
                let eventId = dict["eventId"] as! String
                self.allKeysRegisterEvents.append(eventId)
                //   print(eventId)
            }
            
        }, withCancel: nil)
    }
    
    func randomString(length: Int) -> String {
        let letters = "0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()!})
    }
    
    
    fileprivate func createEvent() {
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("User").child(uid).child("enrollment").child("event").childByAutoId()
        
        
        var key: String?

        if allKeysRegisterEvents.isEmpty{
            key = eventKey
        }else{
            for item in allKeysRegisterEvents{
                if eventKey != item{
                    key = eventKey
                }else{
                    //self.showAlert(title: "Error", message: "You Are Already Registered in this Event", style: .alert)
                    self.showAlert(title: "Important", message: "You Are Already Registered in this Event and your register code #event\(self.code)", style: .alert) { (UIAlertAction) in
                    }
                    return
                }
            }
        }


        guard let eventK = key , !eventK.isEmpty else {return}
        
        let eventKeyRegister  = ["eventId" : eventK]
        
        ref.setValue(eventKeyRegister) { (err, ref) in
            if let error = err {
                print("failed to update/push data in Database", error.localizedDescription)
                return
            }else{
                print("suessfully update Data in DataBase")
                self.code = self.randomString(length: 5)
                let alert = UIAlertController(title: "Register Course", message: "Save your register code #event\(self.code)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        //        ref.updateChildValues(wishListValue, withCompletionBlock: { (error, ref ) in
        //            if let error = error {
        //                print("failed to update/push data in Database", error.localizedDescription)
        //            }else{
        //                print("suessfully update Data in DataBase")
        //            }
        //        })
    }
    
    
    @IBAction func registerBtn(_ sender: Any) {
         self.createEvent()
    }
    
  

}
