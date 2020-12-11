//
//  SettingsViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 6/1/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutLayout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.parent?.title = "Settings"
    }

    @IBAction func profileBtnAction(_ sender: Any) {
//        let profileVc = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC")
//        self.navigationController?.pushViewController(profileVc, animated: true)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
                do{
                    try Auth.auth().signOut()
                    let LoginVc = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    self.navigationController?.pushViewController(LoginVc, animated: true)
                }catch{
                    print("error .. can not LogOut From user Account", error.localizedDescription)
                }
    }
    
}
