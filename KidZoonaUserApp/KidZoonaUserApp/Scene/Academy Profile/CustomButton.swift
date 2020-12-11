//
//  CustomButton.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 5/27/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var shadowColor : UIColor? = .lightGreyBlue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setupShadow()
        
        //        setTitle("Academy Courses", for: .normal)
        setTitleColor(.white, for: .normal)
        
        backgroundColor = .goldenYellow
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius = 15
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.goldenYellow.cgColor
    }
    
    private func setupShadow(){
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.25
        clipsToBounds = true
        layer.masksToBounds = false
    }
}

