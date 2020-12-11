//
//  HomeVC.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 5/20/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import UserNotifications


class HomeVC: UIViewController {

    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    
    @IBOutlet weak var offersCollectionView: UICollectionView!
    
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    
    @IBOutlet weak var offers_lbl: UILabel!
    
    var events = [Event]()
    var eventKey =  [String]()
    var headerIndexArr = Int()
    var courses = [Course]()
    var courseMusic = [Course]()
    var courseDrawing = [Course]()
    var courseRobotics = [Course]()
    var courseChess = [Course]()
    var courseScience = [Course]()
    
    //array of Offers still static array
    let arrayTest = ["Offers", "Music", "Drawing", "Robotics", "Chess", "Science"]

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        notify()
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        offersCollectionView.delegate = self
        offersCollectionView.dataSource = self
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        
        setupCollectionViewLayout()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 37/255 , green: 128/255 , blue: 219/255 , alpha: 1)
        
        //retrieveDataCourses()

        retrieveData()
        getAcademiesData()
        
    }
    
    func notify(){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Welcome"
        content.body = "Welcome to Kidzoona let's start our journey"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
        center.add(request){(error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveDataCourses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Home"
        
        
    }
    
    fileprivate func setupCollectionViewLayout(){
        let layoutHeader = self.headerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutHeader.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        headerCollectionView.showsHorizontalScrollIndicator = false
        
        let layoutOffers = self.offersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutOffers.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        offersCollectionView.showsHorizontalScrollIndicator = false
        
        let layoutEvent = self.eventsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutEvent.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layoutEvent.minimumLineSpacing = 5
        eventsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    
    fileprivate func retrieveDataCourses(){
        self.courses.removeAll()
        self.courseMusic.removeAll()
        self.courseDrawing.removeAll()
        self.courseRobotics.removeAll()
        self.courseChess.removeAll()
        self.courseScience.removeAll()
        
        Database.database().reference().child("Academies").observe(.childAdded, with: { (snapshot) in
            snapshot.children.forEach { (data) in
                let snap = data as! DataSnapshot
                //  print(snap.key)
                if "\(snap.key)" == "courses"{
                    // print("found")
                    snap.children.forEach { (data2) in
                        let snap2 = data2 as! DataSnapshot
                        guard  let dict = snap2.value as? [String: Any] else {return}
                        guard let info = dict["information"] as? [String: Any] else {return}
                        //   print("info: \(info)")
                        let course = Course(dictionary: info)
                        self.courses.append(course)
                        self.offersCollectionView.reloadData()
                        if course.type == "Music"{
                            self.courseMusic.append(course)
                        }else if course.type == "Drawing"{
                            self.courseDrawing.append(course)
                        }else if course.type == "Robot"{
                            self.courseRobotics.append(course)
                        }else if course.type == "Chess"{
                            self.courseChess.append(course)
                        }else if course.type == "Science"{
                            self.courseScience.append(course)
                        }
                        
                        // guard let courseType = info["courseType"] as? String else {return}
                        // print("courseType: \(self.courses.first?.type)")
                    }
                }
                
            }
            
        }) { (err) in
            print("failed to fetch data envnt", err)
        }
    }
    
    
    fileprivate func retrieveData() {
        let ref :  DatabaseReference!
        ref = Database.database().reference()
        
        //guard let userId = Auth.auth().currentUser?.uid else {return}
        ref.child("Academies").observe(.value, with: { (snapshot) in
            
            
            snapshot.children.forEach({ (data) in
                // print(data)
                let snap = data as! DataSnapshot
                snap.children.forEach{ (dataEv) in
                    let snap2 = data as! DataSnapshot
                    // print(snap2)
                    snap2.children.forEach({ (data2) in
                        let snap = data2 as! DataSnapshot
                        print("name of snap :\(snap)")
                        let dic = snap.value as! [String : Any]
                        let comment = dic["name"] as? String
                        print("name of academy :\(comment)")
                    })
                    
                }
                
            })
            
        }, withCancel: nil)
        
    }
    
    fileprivate func getAcademiesData(){
        
        let ref = Database.database().reference()
        let academiesRef = ref.child("Academies")
        academiesRef.observe( .value, with: {  snapshot in
            if let academiesList = snapshot.value as? [String : Any]{
                let academiesIds = academiesList.keys
                print("AllKey\(academiesIds)")
                for id in academiesIds{
                    let academy = academiesList[id] as? [String : Any]
                    let event = academy?["Events"] as? [String : Any]
                    //event?["key"] = id  // Hena mask IDs kol Academy lw7dha
                    //var event = Event(dictionary: information!) // hena d5lt goa el event root eli t7t kol academy
                    //print("event key : \(event?.keys)") // hena mska kol el IDs bt3t el events bs kol events for one academy in one array
                    let eventsIds = event?.keys
                    //  print("events key : \(eventsIds)")
                    for key in eventsIds!{
                        print("keyyyy : \(key)")
                        self.eventKey.append(key)
                        /// hena kol key event lw7doooooooo a5eraaaaaaaaaan ^_^
                        let asmaa = event?[key] as? [String : Any]
                        print("ya rab tb2a hia de : \(asmaa)")
                        //   let eventName2 = asmaa?["name"]
                        //     print("isa hia de: \(eventName2)")
                        let event = Event(dictionary: asmaa!)
                        self.events.append(event)
                        // self.eventName.append(eventName2 as! String)
                        print("evntsNameConnt: \(self.events.count)")
                        self.eventsCollectionView.reloadData()
                        let eventImage = asmaa?["image"]
                        print("sorha URLs : \(eventImage)")
                    }
                    
                }
            }
            
        })
    }
    
}


//extension of three Collection Views in HomeVC
extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return arrayTest.count
        }else if collectionView == offersCollectionView {
            
            switch headerIndexArr {
            case 0:
                return courses.count
            case 1:
                return courseMusic.count
            case 2:
                return courseDrawing.count
            case 3 :
                return courseRobotics.count
            case 4:
                return courseChess.count
            case 5:
                return courseScience.count
            default:
                return 0
            }
            
        }else {
            print("Event name count in number of item:  \(events.count)")
            return events.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! headerCollectionViewCell
            cell.titleOfCatagories.text = arrayTest[indexPath.row]
            cell.layer.cornerRadius = 35
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.masksToBounds = true
            
            if headerIndexArr == indexPath.row{
                
                cell.backgroundColor = .lightGray
                cell.titleOfCatagories.textColor = .white
            }else{
                
                cell.backgroundColor = .white
                cell.titleOfCatagories.textColor = .black
                
            }
            
            return cell
            
        }else if collectionView == offersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OffersCell", for: indexPath) as! OffersCellCollectionViewCell
            
            switch headerIndexArr {
            case 0:
                 offers_lbl.text = "Offers"
                cell.courseNameInOffersCollection.text = courses[indexPath.row].name
                let imageUrl = courses[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courses[indexPath.row].offer
            case 1:
                 offers_lbl.text = "Music"
                cell.courseNameInOffersCollection.text = courseMusic[indexPath.row].name
                let imageUrl = courseMusic[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courseMusic[indexPath.row].offer
            case 2:
                offers_lbl.text = "Drawing"
                cell.courseNameInOffersCollection.text = courseDrawing[indexPath.row].name
                let imageUrl = courseDrawing[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courseDrawing[indexPath.row].offer
            case 3 :
                offers_lbl.text = "Robotics"
                cell.courseNameInOffersCollection.text = courseRobotics[indexPath.row].name
                let imageUrl = courseRobotics[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courseRobotics[indexPath.row].offer
            case 4:
                offers_lbl.text = "Chess"
                cell.courseNameInOffersCollection.text = courseChess[indexPath.row].name
                let imageUrl = courseChess[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courseChess[indexPath.row].offer
            case 5:
                offers_lbl.text = "Science"
                cell.courseNameInOffersCollection.text = courseScience[indexPath.row].name
                let imageUrl = courseScience[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courseScience[indexPath.row].offer
            default:
                offers_lbl.text = "Offers"
                cell.courseNameInOffersCollection.text = courses[indexPath.row].name
                let imageUrl = courses[indexPath.row].image
                cell.offerImageInOffersCollection.sd_setImage(with: URL(string: imageUrl)!, placeholderImage: UIImage(named: "course4"))
                cell.courseDiscountInOffersCollection.text = courses[indexPath.row].offer
            }
            
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventCellCollectionViewCell
            cell.eventNameInEventCollection.text = events[indexPath.row].name
            let imagUrlArray = self.events[indexPath.row].image
            print("imageArray \(imagUrlArray)")
            let photoURL = URL(string: (imagUrlArray))
            // print("UserImage : \(photoURL)")
            
            if let url = photoURL{
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil){ (image , error, cache, coursename) in
                    cell.eventImageInEventCollection.image = image
                    cell.eventImageInEventCollection.kf.indicatorType = .activity
                    
                }
            }
            else {
                cell.eventImageInEventCollection.image = UIImage(named: "noimage")
                
            }
            
            
            return cell
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == headerCollectionView{
            headerIndexArr = indexPath.row
            self.headerCollectionView.reloadData()
            retrieveDataCourses()
        }
        
        if collectionView == offersCollectionView{
            let courseDetails = UIStoryboard(name: "CourseList", bundle: nil).instantiateViewController(withIdentifier: "CourseDetails") as! CourseDetailsViewController
            switch headerIndexArr {
            case 0 :
                courseDetails.myCourse = courses[indexPath.row]
            case 1 :
                courseDetails.myCourse = courseMusic[indexPath.row]
            case 2 :
                courseDetails.myCourse = courseDrawing[indexPath.row]
            case 3 :
                courseDetails.myCourse = courseRobotics[indexPath.row]
            case 4 :
                courseDetails.myCourse = courseChess[indexPath.row]
            case 5 :
                courseDetails.myCourse = courseScience[indexPath.row]

            default:
                courseDetails.myCourse = courses[indexPath.row]

            }
            
            self.navigationController?.pushViewController(courseDetails, animated: true)
        }
        
        if collectionView == eventsCollectionView{
            let eventView = UIStoryboard(name: "Event", bundle: nil).instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
            
            eventView.image = events[indexPath.row].image
            eventView.name = events[indexPath.row].name
            eventView.date = events[indexPath.row].date
            eventView.time = events[indexPath.row].time
            eventView.price = events[indexPath.row].price
            eventView.descrption = events[indexPath.row].descrption
            eventView.location = events[indexPath.row].location
            eventView.availableSeats = events[indexPath.row].availableSeats
            eventView.eventKey = eventKey[indexPath.row]
            
            
            
            self.navigationController?.pushViewController(eventView, animated: true)
        }
    }
    
}


extension HomeVC : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
