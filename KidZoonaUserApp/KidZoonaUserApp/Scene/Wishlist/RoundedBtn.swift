//
//  RoundedBtn.swift
//  KidZoonaUserApp
//
//  Created by Hagar Diab on 5/29/20.
//  Copyright © 2020 asmaa. All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
