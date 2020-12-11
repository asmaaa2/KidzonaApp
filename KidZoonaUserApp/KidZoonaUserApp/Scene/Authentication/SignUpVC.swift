//
//  SignUpVC.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 5/20/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class SignUpVC: UIViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    
    @IBOutlet weak var lastNameTxt: UITextField!
    
    @IBOutlet weak var emailRegTxt: UITextField!
    
    @IBOutlet weak var passRegTxt: UITextField!
    
    @IBOutlet weak var birthDate: UITextField!
    
    @IBOutlet weak var signUpBtnOutlet: UIButton!
    
    
    let datePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegView()
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    fileprivate func setupRegView(){
        firstNameTxt.layer.cornerRadius = 15
        firstNameTxt.layer.borderWidth = 1
        firstNameTxt.layer.borderColor = UIColor.lightGray.cgColor
        
        lastNameTxt.layer.cornerRadius = 15
        lastNameTxt.layer.borderWidth = 1
        lastNameTxt.layer.borderColor = UIColor.lightGray.cgColor
        
        emailRegTxt.layer.cornerRadius = 15
        emailRegTxt.layer.borderWidth = 1
        emailRegTxt.layer.borderColor = UIColor.lightGray.cgColor
        
        passRegTxt.layer.cornerRadius = 15
        passRegTxt.layer.borderWidth = 1
        passRegTxt.layer.borderColor = UIColor.lightGray.cgColor
        
        birthDate.layer.cornerRadius = 15
        birthDate.layer.borderWidth = 1
        birthDate.layer.borderColor = UIColor.lightGray.cgColor
        
        signUpBtnOutlet.layer.cornerRadius = 15
        
        createDatePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        birthDate.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        birthDate.inputAccessoryView = toolbar
        birthDate.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        birthDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        guard let firstName = self.firstNameTxt.text , firstName != "" else {
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your first name")
            
            print("you must enter your name")
            return
            
        }
        guard let lastName = self.lastNameTxt.text , lastName != "" else {
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your last name")
            print("you must enter your name")
            return
        }
        
        guard let email = emailRegTxt.text, email != "" else {
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your email")
            return
        }
        guard let pass = passRegTxt.text, pass != "" else{
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your Password")
            print("please enter your Password")
            return
        }
       
        guard let emailAddress = self.emailRegTxt.text , emailAddress != "" else {
            print("you must enter your name")
            return
        }
        // Register the User to Firebase
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if let error = error{
                print("failed to sign up firebase", error.localizedDescription)
                return
            } else {
                print("Successfully SignUp")
                let userName = "\(firstName) \(lastName)"
                let userBirthDateTxt =  self.birthDate.text
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let ref = Database.database().reference().child("User").child(uid).child("Information")
                let dicValues: [String: Any] = ["UserName" : userName , "userEmail" : emailAddress, "birthDate" : userBirthDateTxt]
                ref.updateChildValues(dicValues, withCompletionBlock: { (error, ref ) in
                    if let error = error {
                        print("failed to update/push data in Database", error.localizedDescription)
//                        var errorTxt = error.localizedDescription
//                        let alert = UIAlertController(title: "Error Message", message: errorTxt, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                        alert.present(alert, animated: true, completion: nil)
                    }else{
                        let def = UserDefaults()
                        def.setValue(userName, forKey: "userName")
                        def.setValue(userBirthDateTxt, forKey: "userBirthDate")
                        def.synchronize()
                        print("suessfully update Data in DataBase")
                    }
                })
                
            }
        }
    }
    
    
    
    @IBAction func logInRegBtn(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    

}
