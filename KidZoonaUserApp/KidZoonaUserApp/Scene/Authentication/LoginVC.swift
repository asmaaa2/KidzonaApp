//
//  LoginVC.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 5/20/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import AppAuth
import FBSDKLoginKit
import Firebase
import FBSDKCoreKit

class LoginVC: UIViewController{

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var signInBtnOutlet: UIButton!
    
    @IBOutlet weak var fbBtnOutLet: UIButton!
    
    var isSignIn: Bool = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.navigationController?.isNavigationBarHidden = true
        
        //3
        GIDSignIn.sharedInstance().delegate = self
       // fbBtnOutLet.delegate = self
       // fbBtnOutLet.permissions = ["public_profile","email"]
    }
    
    fileprivate func setupView(){
        
        emailText.layer.cornerRadius = 15
        emailText.layer.borderWidth = 1
        emailText.layer.borderColor = UIColor.lightGray.cgColor
        
        passwordText.layer.cornerRadius = 15
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        
        signInBtnOutlet.layer.cornerRadius = 15
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        guard let email = emailText.text, email.count > 0 else {
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your email")
            print("please enter your Email Address")
            return
        }
        guard let pass = passwordText.text, pass.count > 0 else{
            AlertController.showAlert(inViewController:self, title: "Alert", message: "Please enter your password")

            print("please enter your Password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            //check the user is not nil
            if let error = error{
                AlertController.showAlert(inViewController:self, title: "Alert", message: "email or password is wrong")

                print("failed to SignIn", error.localizedDescription)
                return
            }else if let user = user{
                print("successfully SignIn", user.user.email ?? "")
//                let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootNavHomeX")
//                self.navigationController?.pushViewController(home, animated: true)
            }
        }
    }
    
    @IBAction func forgetPassBtn(_ sender: Any){
        let alert = UIAlertController(title: "Email", message: "Please Enter Your Email Address", preferredStyle: .alert)
        alert.addTextField { (tf: UITextField) in
            tf.placeholder = "Enter Your Email Address"
            tf.keyboardType = .emailAddress
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action : UIAlertAction) in
            if let email = alert.textFields?.first?.text, !email.isEmpty{
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if let error = error{
                        print("there is error in forget password reset", error.localizedDescription)
                    }
                    else{
                        print("success to reset password and check your Email")
                    }
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func fbBtn(_ sender: Any) {
        print("Heyyyy Suger")
        let manager = LoginManager()
        manager.logIn(permissions: ["public_profile","email"], from: self) { (result, err) in
            if !result!.isCancelled {
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "nil")
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error{
                        print("Failed to sigin by facebook", error)
                    }else if let users = user{
                        print("User ProviderID: \(users.user.providerID)")
                        print("User Name: \(users.user.displayName)")
                        print("User Email: \(users.user.email)")
                        print("User UID: \(users.user.uid)")
                        print("User Number: \(users.user.phoneNumber)")
                        
                        for profile in users.user.providerData{
                            print("User ProviderID: \(profile.providerID)")
                            print("User Name: \(profile.displayName)")
                            print("User Email: \(profile.email)")
                            print("User UID: \(profile.uid)")
                            print("User PhotoURl: \(profile.photoURL)")
                            print("User Number: \(profile.phoneNumber)")
                            
                        }
                        
                        
                        
                        print("User log in By Facebook")
                        
                    }
                }
            }else {
                print("User is cancelled login")
            }
        }
        
    }
    
    @IBAction func googleBtn(_ sender: Any) {
        
        //4
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        
        let registerationVC = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC")
        navigationController?.pushViewController(registerationVC, animated: true)
        
    }
    
}

extension LoginVC : GIDSignInDelegate, LoginButtonDelegate {
    
    //5
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("error in SignIn", error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error", error.localizedDescription)
            }else if let users = user{
                print("User ProviderID: \(users.user.providerID)")
                print("User Name: \(users.user.displayName)")
                print("User Email: \(users.user.email)")
                print("User UID: \(users.user.uid)")
                print("User Number: \(users.user.phoneNumber)")
                
                for profile in users.user.providerData{
                    print("User ProviderID: \(profile.providerID)")
                    print("User Name: \(profile.displayName)")
                    print("User Email: \(profile.email)")
                    print("User UID: \(profile.uid)")
                    print("User PhotoURl: \(profile.photoURL)")
                    print("User Number: \(profile.phoneNumber)")
                    
                }
                
                print("User logIn By Gmail")
                
            }
        }
    }
    
    //6
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("user is discounting")
    }
    
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton) -> Bool {
        return true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error{
            print("Failed to sigin by facebook", error)
            return
        }else{
            if !result!.isCancelled {
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current?.tokenString ?? "nil")
                
                Auth.auth().signIn(with: credential) { (user, error) in
                    if let error = error{
                        print("Failed to sigin by facebook", error)
                    }else if let users = user{
                        print("User ProviderID: \(users.user.providerID)")
                        print("User Name: \(users.user.displayName)")
                        print("User Email: \(users.user.email)")
                        print("User UID: \(users.user.uid)")
                        print("User Number: \(users.user.phoneNumber)")
                        
                        for profile in users.user.providerData{
                            print("User ProviderID: \(profile.providerID)")
                            print("User Name: \(profile.displayName)")
                            print("User Email: \(profile.email)")
                            print("User UID: \(profile.uid)")
                            print("User PhotoURl: \(profile.photoURL)")
                            print("User Number: \(profile.phoneNumber)")
                            
                        }
                        
                        print("User log in By Facebook")
                        
                    }
                }
            }else {
                print("User is cancelled login")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Facebook user logged out")
    }
    
    
}
