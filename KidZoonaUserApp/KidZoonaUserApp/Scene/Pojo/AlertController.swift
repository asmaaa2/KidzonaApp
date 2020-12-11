//
//  AlertController.swift
//  KidzoonaAcademy
//
//  Created by Marwan Magdy on 6/1/20.
//  Copyright © 2020 Marina Sameh. All rights reserved.
//

import UIKit

class AlertController{
    
    static func showAlert (inViewController: UIViewController, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        inViewController.present(alert, animated: true, completion: nil)
    }
}
