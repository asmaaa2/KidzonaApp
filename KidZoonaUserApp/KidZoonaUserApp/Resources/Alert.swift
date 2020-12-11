//
//  Alert.swift
//  KidZoonaUserApp
//
//  Created by MacOSSierra on 6/14/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController{
    
    func showAlert(title: String, message: String, style: UIAlertController.Style, okTitle: String = "OK", okHandle: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: okHandle))
        present(alert, animated: true, completion: nil)
    }
    
}
