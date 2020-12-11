//
//  EditProfileViewController.swift
//  KidZoonaUserApp
//
//  Created by Marina Sameh on 5/25/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var userImageOutLet: UIImageView!
    
    let datePicker = UIDatePicker()
    var  gender : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userName.layer.cornerRadius = 15
        userName.layer.borderWidth = 1
        userName.layer.borderColor = UIColor.lightGray.cgColor
  
        birthDate.layer.cornerRadius = 15
        birthDate.layer.borderWidth = 1
        birthDate.layer.borderColor = UIColor.lightGray.cgColor
        
        saveBtn.layer.cornerRadius = 15

        createDatePicker()
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func male(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            femaleBtn.isSelected = false
        } else {
            sender.isSelected = true
            femaleBtn.isSelected = false
            gender = "male"
        }
    }
    
    
    @IBAction func female(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
            maleBtn.isSelected = false
        } else {
            sender.isSelected = true
            maleBtn.isSelected = false
            gender = "female"
        }
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
 
    @IBAction func uploadPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func saveEditUserInfo(_ sender: Any) {
        guard let userImg = userImageOutLet.image else { return }
        guard let uploadImg = userImg.jpegData(compressionQuality: 0.3) else { return }  //compress img
        let fileName = NSUUID().uuidString  //make file to arange

        let ref = Storage.storage().reference().child("UserProfileImage").child(fileName)
        ref.putData(uploadImg, metadata: nil) { (metaData, error) in
            if let error = error {
                print("failed to uploadImg", error.localizedDescription)
                return
            }
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("failed to uploadImg", error.localizedDescription)
                    return
                }
                guard let profileImagUrl = url?.absoluteString else {
                    print("something wrong when get url image")
                    return
                }
                print("succefully upload profile image \(profileImagUrl)")

                guard let uid = Auth.auth().currentUser?.uid else {return}
                let ref = Database.database().reference().child("User").child(uid).child("Information")
                let dicValue = ["profileImage": profileImagUrl]
                ref.updateChildValues(dicValue, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to push user image", err.localizedDescription)
                    }

                    print("Succefully put image")
                })



            })
        }
        
        //updateFunBirthdate
        updateUserData()
        
        
    }
    
    func updateUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let refe = Database.database().reference().child("User").child(uid).child("Information")
        
        ///// handle if user Name& birthDate if Texts = nil
        var fullname: String?
        var usrNameTxt = userName.text
        var birthdate : String?
        var userBirthDateTxt =  birthDate.text
        let def = UserDefaults()
        let fullNameDef = def.value(forKey: "userName") as? String
        let birthdateDef = def.value(forKey: "userBirthDate") as? String
        
        print("fullNameDef : \(fullNameDef)")
        print("birthdateDef : \(birthdateDef)")
        
        if usrNameTxt == "" {
            fullname = fullNameDef
        }else{
            fullname = usrNameTxt
        }
        if userBirthDateTxt == ""{
            birthdate = birthdateDef
        }else{
            birthdate = userBirthDateTxt
        }
        /////

        let birthDateTxt: [String: Any] = ["birthDate" : birthdate, "UserName" : fullname, "gender": gender]
        
        print("birthDateTxt :  \(birthDateTxt)")
        
        refe.updateChildValues(birthDateTxt, withCompletionBlock: { (error, ref ) in
            if let error = error {
                print("failed to update UserData in Database", error.localizedDescription)
               
            }else{
                print("suessfully update UserData in DataBase")

                self.birthDate.text = ""
                self.userName.text = ""
            }
        })
      
        self.navigationController?.popViewController(animated: true)
    }
}


//
extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageOutLet.image = editImage
        }else if let selectImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageOutLet.image = selectImage
        }
       picker.dismiss(animated: true, completion: nil)
    }
}

