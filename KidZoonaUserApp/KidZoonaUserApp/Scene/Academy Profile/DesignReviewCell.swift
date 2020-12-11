//
//  DesignReviewCell.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 5/27/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

@IBDesignable class DesignReviewCell: UIView {
    
    @IBInspectable var cornerRadius :  CFloat = 0
    @IBInspectable var shadowColor : UIColor? = .whiteThree
    
    @IBInspectable let shadowOffSetWidth : Int = 0
    @IBInspectable let shadowOffSetHeight : Int = 1
    
    @IBInspectable var shadowOpacity : Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(cornerRadius))
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
}
