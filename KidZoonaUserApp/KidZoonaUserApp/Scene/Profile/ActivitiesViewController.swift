//
//  ActivitiesViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 5/25/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Kingfisher

class ActivitiesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
   

    @IBOutlet weak var tableView: UITableView!
    var name: NSArray = []
    var imgArr: NSArray = []
    var academyName: NSArray = []
    var date: NSArray = []
    
    var courseArr = [String]()
    var allCourseKeys = [String]()
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
//        name = ["Wedo","Drawing","Music","chess"]
//        imgArr = [UIImage(named: "course1")!,UIImage(named: "course4")!,UIImage(named: "course5")!,UIImage(named: "course7")!]
//        academyName = ["Metanoia", "Treasures", "Metanonia", "KDC"]
//        date = ["1/6/2020", "5/6/2020", "10/6/2020", "12/6/2020"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will appear")
        getCourseKeys()
        self.courses = []

        
    }
    
   func getCourseKeys(){
    print("in get courses")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("User").child(uid).child("enrollment").child("course").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // guard let userDic = snapshot.value as? [String:Any] else {return}
            snapshot.children.forEach { (data) in
                let snap = data as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let eventId = dict["courseId"] as? String
                //  print("eventId \(eventId)")
                self.courseArr.append(eventId ?? "nil")
               // self.tableView.reloadData()
            }
            self.retriveDataFromAcadmeies()
            
            
        }) { (err) in
            print("Failed to fetch user post", err)
        }
    }
    
    
   func retriveDataFromAcadmeies(){
    print("in retrieve in courses")
    let academiesRef = Database.database().reference().child("Academies")
    academiesRef.observe(.value) { (snapshot) in
        self.courses = []
        if let academiesList = snapshot.value as? [String : Any]{
            
            let academiesIds = academiesList.keys
            print("AllKey\(academiesIds)")
            for id in academiesIds{
                let academy = academiesList[id] as? [String : Any]
                
//                var information = academy?["Information"] as? [String : Any]
//                information?["key"] = id
                
                
                //create ref to courses
                
                let academyCoursesList = academy?["courses"] as? [String : Any]
                print("coursesNode\(academyCoursesList)")
                let coursesIds = academyCoursesList!.keys
                 print("coursesKeys\(coursesIds)")
                for courseId in coursesIds{
                    if self.courseArr.contains(courseId){
                        let course = academyCoursesList![courseId] as? [String : Any]
                        var courseInformation = course?["information"] as? [String : Any]
                        courseInformation?["key"] = coursesIds
                        let courseInfoDict = Course(dictionary: courseInformation!)
                        self.courses.append(courseInfoDict)
                        
                    }
               
                }
  
            } // end of for
            
            self.tableView.reloadData()
        }
        
    }
    
    
    
//        Database.database().reference().child("Academies").observe(.childAdded, with: { (snapshot) in
//            snapshot.children.forEach { (data) in
//                let snap = data as! DataSnapshot
//                //  print(snap.key)
//                if "\(snap.key)" == "information"{
//                    // print("found")
//                    snap.children.forEach { (data2) in
//                        let snap2 = data2 as! DataSnapshot
//                        guard  let dict = snap2.value as? [String: Any] else {return}
//                        //  print(snap2.key)
//                        // print(self.eventArr)
//                        for id in self.courseArr{
//
//                            if "\(snap2.key)" == id {
//                                // print("is equel")
//                                let course = Course(dictionary: dict)
//                                self.courses.append(course)
//                                self.tableView.reloadData()
//                                print("Course name: \(course.name)")
//                            }
//                        }
//                    }
//                }
//
//            }
//
//        }) { (err) in
//            print("failed to fetch data envnt", err)
//        }
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivitiesForUserTabelCell
        
        cell.courseName.text! = courses[indexPath.row].name
        cell.academyName.text! = courses[indexPath.row].price
        cell.courseDate.text! = courses[indexPath.row].date
        let url = URL(string: ((courses[indexPath.row].image)))
        if let url = url as? URL{
            KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil){ (image , error, cache, coursename) in
                cell.courseImage.image = image
                cell.courseImage.kf.indicatorType = .activity
            }
        }
        
//        let imagUrl = courses[indexPath.row].image
//        
//        cell.courseImage.sd_setImage(with: URL(string: imagUrl)!, placeholderImage: UIImage(named: "course4"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109
    }

}
