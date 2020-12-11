//
//  RoundedButton.swift
//  KidzoonaAcademy
//
//  Created by Marwa Zabara on 5/27/20.
//  Copyright © 2020 Marina Sameh. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func prepareForInterfaceBuilder() {
        CustomizeButton()
    }
    
    
    override func awakeFromNib() {
        super .awakeFromNib()
        CustomizeButton()
        
    }
    
    func CustomizeButton() {
        //        backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
        //layer.borderWidth = 1.0
        
        
        
        /*
         // Only override draw() if you perform custom drawing.
         // An empty implementation adversely affects performance during animation.
         override func draw(_ rect: CGRect) {
         // Drawing code
         }
         */
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
