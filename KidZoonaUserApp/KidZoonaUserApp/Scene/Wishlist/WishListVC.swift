//
//  WishListVC.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 5/27/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import Firebase

class WishListVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    var dbRef : DatabaseReference?
    var wishlistedCoursesIds = [String]()
    
    var wishlistedCoursesArr = [Course]()
    
//    var name: NSArray = []
//    var imgArr: NSArray = []
//    var academyName: NSArray = []
//    var date: NSArray = []
    
//    var cardView: DesignCourseList!
//    var rate: CosmosView!
//    var favouriteBtn: RoundedBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        name = ["Wedo","Drawing","Music","chess"]
//        imgArr = [UIImage(named: "course1")!,UIImage(named: "course4")!,UIImage(named: "course5")!,UIImage(named: "course7")!]
//        academyName = ["Metanoia", "Treasures", "Metanonia", "KDC"]
//        date = ["1/6/2020", "5/6/2020", "10/6/2020", "12/6/2020"]
        
//        setUpNavigationBarItems()
        
        dbRef = Database.database().reference()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Wishlist"
        retriveWishListedCourses()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return name.count
        return wishlistedCoursesArr.count //will increased by events count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WishTableViewCell
        
        cell.courseObj = wishlistedCoursesArr[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    // delete cell from table view and the course id from firebase widhlist node
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                guard let uId = Auth.auth().currentUser?.uid else {
                    print("cannot find userID")
                    return
                }
                
//                self.dbRef?.child("User").child(uId).child("WishList").child("Courses").child("courseId").child(self.wishlistedCoursesIds[indexPath.row]).removeValue()
                self.wishlistedCoursesArr.remove(at: indexPath.row)
                self.wishlistedCoursesIds.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .bottom)
                
                let wishCourseValue = ["courseId" : self.wishlistedCoursesIds] as? [String : [String]]
                self.dbRef?.child("User").child(uId).child("WishList").child("Courses").updateChildValues(wishCourseValue!, withCompletionBlock: { (error, dbRef) in
                    if let err = error{
                        print("Filed to delete element from wishlist node ", err.localizedDescription)
                        
                    }else{
                        print("Suessfully delete wishlist element")
                    }
                })
//                self.wishlistedCoursesArr = []
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDetails = UIStoryboard(name: "CourseList", bundle: nil)
//        let courseDetailsController = self.storyboard!.instantiateViewController(withIdentifier: "CourseList")
        let selectedCourse = wishlistedCoursesArr[indexPath.row]
        
        performSegue(withIdentifier: "toCourseDetailsView", sender: selectedCourse)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toCourseDetailsView"){
            let courseDetailsVC = segue.destination as! CourseDetailsViewController
            courseDetailsVC.myCourse = sender as? Course
        }
    }
    
    
}

extension WishListVC{
    
    private func retriveWishListedCourses(){
        wishlistedCoursesIds = []
        guard let uId = Auth.auth().currentUser?.uid else {
            print("cannot find userID")
            return
        }
        
//        print("Wishlist")

        let userRef = dbRef!.child("User").child(uId)
        let wishlistRef = userRef.child("WishList")
        let wishCoursesList = wishlistRef.child("Courses").child("courseId")
        wishCoursesList.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                print("childSnap\(child)")
                let snap = child as! DataSnapshot
                
                let courseId = snap.value as! String
//                print("WishlistedCoursesIdVC\(courseId)")
                self.wishlistedCoursesIds.append(courseId)
//                self.wishlistedCoursesIds = courseId
//                self.wishlistedCoursesIds += courseId
//                print("WishlistedCoursesIdArrayVC\(self.wishlistedCoursesIds)")
            }
            self.getCoursesData(coursesIds: self.wishlistedCoursesIds)
        })  
    }
    
    private func getCoursesData(coursesIds : [String]){
        wishlistedCoursesArr = []
        
        let academiesRef = dbRef?.child("Academies")
        academiesRef?.queryLimited(toLast: 10).observe(.value, with: { [weak self] snapshot in
            
            if let academiesList = snapshot.value as? [String : Any]{
                
                let academiesIds = academiesList.keys
                for id in academiesIds{
                    let academy = academiesList[id] as? [String : Any]
                    
                    let academyCoursesList = academy?["courses"] as? [String : Any]
                    print("coursesNode\(academyCoursesList)")

                    for courseId in coursesIds{
                        
                        let course = academyCoursesList![courseId] as? [String : Any ]
                        //                    print("SingleCourseData\(String(describing: course))")
                        if course == nil {
                            continue
                        }else{
                            var courseInformation = course!["information"] as? [String : Any]
                            courseInformation!["key"] = courseId
                            //                    print("SingleCourseInformation\(String(describing: courseInformation))") // till here true
                            let courseInfoDict = Course(dictionary: courseInformation!)
                            
                            self?.wishlistedCoursesArr.append(courseInfoDict)
                            //  var courseReview = course?["review"] as? [String : Any]
                            
                        }
                    }
//                    print("wishlistVCArray\(self?.wishlistedCoursesArr)")
                }
                self!.tableView.reloadData()
            }
            
        })
    }
    
    //    private func setUpNavigationBarItems(){
    //        let barTitle = "Wishlist"
    //        navigationItem.title = barTitle
    //        navigationController?.navigationBar.barTintColor = .warmGrey
    //        navigationController?.navigationBar.isTranslucent = false
    //
    //    }
    
}

