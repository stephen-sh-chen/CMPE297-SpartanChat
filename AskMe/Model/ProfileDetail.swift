//
//  ProfileDetail.swift
//  AskMe
//
//  Created by Maryam Jafari on 12/4/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
class ProfileDetail{
    private var _address = ""
    private var _interest = ""
    private var _schoolYear = ""
    private var _major = ""
      private var _userId = ""
      private var _userEmail = ""
    private var _latitude : Double! = 0.0
    private var _lon : Double! = 0.0
    init() {
    
    }
    init(address : String, interest : String, schoolYear: String, major: String, userid: String, userEmail: String ,latitude : Double, longtitude : Double){
        _address = address
        _interest = interest
        _schoolYear = schoolYear
        _major = major
        _userId = userid
        _userEmail = userEmail
        _latitude = latitude
        _lon = longtitude
    }
    var address : String{
         set { _address = newValue}
        get{
            return _address
        }
    }
    var latitude : Double{
        return _latitude
    }
    var lon : Double{
        return _lon
    }
    var major : String{
        set { _major = newValue}
        get{
            return _major
        }
    }
  
    var username : String{
        set { _userEmail = newValue}
        get{
            return _userEmail
        }
    }
    var userId : String{
        set { _userId = newValue}
        get{
            return _userId
        }
    }
    var interest : String{
        set { _interest = newValue}
        get{
            return _interest
        }
    }
    var year : String{
        set { _schoolYear = newValue}
        get{
            return _schoolYear
        }
    }
    func getCoordinateByUserId(userID: String)->(latitude: Double, longtitud: Double){
        return (_latitude, _lon)
        
    }
    func getUsers() -> [ProfileDetail] {
        var retUrnusers = [ProfileDetail]()
        
                let user = ProfileDetail(address: address, interest: interest, schoolYear: year, major: major, userid: userId, userEmail: username, latitude: latitude, longtitude: lon)
                retUrnusers.append(user)
        
        return retUrnusers
            }
    

 
    
}

