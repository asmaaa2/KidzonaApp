//
//  CourseListViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 5/22/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Firebase

class CourseListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var dbRef : DatabaseReference?
    var currentAcademy : Academy?
    var coursesArr = [Course]()
    
    @IBOutlet weak var tableView: UITableView!
    
//    var name: NSArray = []
//    var imageArray:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorColor = UIColor(white: 0.95, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        
//        name = ["Wedo","EV3","Art","Drawing","Music","Music","chess"]
//        imageArray = [UIImage(named: "course1"),UIImage(named: "course2"),UIImage(named: "course3"),UIImage(named: "course4"),UIImage(named: "course5"),UIImage(named: "course6"),UIImage(named: "course7")!]
        
        
        dbRef = Database.database().reference()
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
//        print("CurrentAcademyObjectFromCoursesViewList\(currentAcademy)")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.title = "Courses"
        
        getAcademyCourses(academyId: (currentAcademy?.id)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return name.count
        return coursesArr.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseListCell
        cell.contentView.backgroundColor = UIColor (white: 0.95, alpha: 1)
        
        cell.courseObj = coursesArr[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseDetails = UIStoryboard(name: "CourseList", bundle: nil)
        var selectCourse = coursesArr[indexPath.row]
        performSegue(withIdentifier: "toCourseDetails", sender: selectCourse)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "toCourseDetails"){
            let courseDetailsVC = segue.destination as! CourseDetailsViewController
            courseDetailsVC.myCourse = sender as? Course
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
}

extension CourseListViewController{

    private func getAcademyCourses(academyId : String){
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        let academyCoursesRef = dbRef?.child("Academies").child(academyId).child("courses")
        academyCoursesRef?.queryLimited(toLast: 10).observe(.value, with: { [weak self] snapshot in
            self?.coursesArr = []
            if let academyCoursesList = snapshot.value as? [String : Any]{
//                print("coursesList\(academyCoursesList)")
                let coursesIds = academyCoursesList.keys
//                print("coursesKeys\(coursesIds)")
    
                for courseId in coursesIds{
                    let course = academyCoursesList[courseId] as? [String : Any ]
//                    print("SingleCourseData\(String(describing: course))")
                    var courseInformation = course!["information"] as? [String : Any]
                    courseInformation!["key"] = courseId
//                    print("SingleCourseInformation\(String(describing: courseInformation))") // till here true
                    let courseInfoDict = Course(dictionary: courseInformation!)
                    self?.coursesArr.append(courseInfoDict)
                    //here we can create review objects to update rating
//                    print("courses Array\(self?.coursesArr)")
                    self?.tableView.reloadData()
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
    
            }
        })
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    
    }

    


}
