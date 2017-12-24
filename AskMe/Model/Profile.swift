//
//  Profile.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
class Profile{
    private var _name = ""
    private var _id = ""
    private var _ImageURL = ""
    
    init(name : String, id : String, imageURL: String){
        _name = name
        _id = id
        _ImageURL = imageURL
    }
    var name : String{
        get{
            return _name
        }
    }
    var imageURl : String{
        set { _ImageURL = newValue}
       get{
            return _ImageURL
       }
    }
    var id : String{
        get{
            return _id
        }
    }
}

