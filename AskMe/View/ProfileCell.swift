//
//  ProfileCell.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileCell: UITableViewCell {


    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        
    }
    
    


    func configureCell(profile : Profile){
     
            let url = URL(string:profile.imageURl)
            let data = try? Data(contentsOf: url!)
            let image: UIImage = UIImage(data: data!)!
        
     
        name.text = profile.name.capitalized
        profileImage.image = image
        
    }

}
