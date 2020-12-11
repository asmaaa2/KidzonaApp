//
//  RoundedTextField.swift
//  KidzoonaAcademy
//
//  Created by Marwa Zabara on 5/27/20.
//  Copyright © 2020 Marina Sameh. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    override func prepareForInterfaceBuilder() {
        CustomizeTextField()
    }
    
    
    override func awakeFromNib() {
        super .awakeFromNib()
        CustomizeTextField()
        
    }
    
    func CustomizeTextField() {
//        backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        layer.cornerRadius = frame.height/2
        textAlignment = .center
        clipsToBounds = true
        layer.borderWidth = 0.5
   
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    }
}
