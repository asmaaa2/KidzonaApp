//
//  AcademyProfileVC.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 5/26/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import Kingfisher

class AcademyProfileVC: UIViewController {
    
    var currentAcademy : Academy?
    var dbRef : DatabaseReference?
    
    var currentRate : Double?
    
    var name: NSArray = []
    var date: NSArray = []
    var rateView: CosmosView!{
        didSet{
            rateView.settings.updateOnTouch = false
            rateView.settings.totalStars = 5
            rateView.settings.fillMode = .full
            rateView.rating = currentRate ?? 4.0
        }
    }

    @IBOutlet weak var academyImage: UIImageView!
    @IBOutlet weak var academyName: UILabel!
    @IBOutlet weak var ratingView: CosmosView! // to get rating
    @IBOutlet weak var academyLocationLabel: UILabel!
    @IBOutlet weak var getDirectionOfAcademyFromMapBtn: UIButton!
    
    @IBOutlet weak var academyReviewTableView: UITableView!
    
    let lineImage: UIImageView = {
        let line = UIImageView()
        line.image = UIImage(named: "line")
        return line
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        academyReviewTableView.delegate = self
        academyReviewTableView.dataSource = self

        
        dbRef = Database.database().reference()
        
        view.backgroundColor  = .whiteTwo
        
        fetchAcademyData()
        
        setUpCosmosUIView()
        
        name = ["Ali","Kero","Mark","Mahmoud"]
        date = ["1/6/2020", "5/6/2020", "10/6/2020", "12/6/2020"]
    }
    
    @IBAction func toAcademyCoursesList(_ sender: Any?) {
        
//        getAcademyCourses(academyId: (currentAcademy?.id)!)
//        performSegue(withIdentifier: "toAcademyCourses", sender: sender)

    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "toAcademyCourses" {
            if let coursesListVC = segue.destination as? CourseListViewController {
                coursesListVC.currentAcademy = self.currentAcademy
            }
        }
        
    }
    
}

extension AcademyProfileVC{
    
    private func fetchAcademyData(){
        academyLocationLabel.text = currentAcademy?.location
        academyName.text = currentAcademy?.name
        
        let url = URL(string: (currentAcademy?.image)!)
        if let imgUrl = url as? URL{
            KingfisherManager.shared.retrieveImage(with: imgUrl as! Resource, options: nil, progressBlock: nil) { (image, error, cache, academyImage) in
                self.academyImage.image = image
                self.academyImage.kf.indicatorType = .activity
            }
        }
        else {
            academyImage.image = UIImage(named: "noimage")
            
        }
    }
    
    private func setUpCosmosUIView(){
        //rating view for academy to get rate
        
        ratingView.settings.fillMode = .full
        ratingView.text = "Rate Us"
        ratingView.didTouchCosmos = {rating in
            
            print("rate is\(rating)")
            
            self.currentRate = rating
            
        }
    }
    
}

////////////////// extension for Academy ReviewTableView

extension AcademyProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! UserReviewCell
        
        cell.reviewDate.text = date[indexPath.row] as? String
        cell.userNameLabel.text = name[indexPath.row] as? String
        cell.rateView = [indexPath.row] as? CosmosView

        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
}
