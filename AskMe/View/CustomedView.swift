//
//  CustomedView.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/13/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit

class CustomedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.9).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    
}
