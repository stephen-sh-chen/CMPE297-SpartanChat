//
//  UserAnnotation.swift
//  AskMe
//
//  Created by Maryam Jafari on 12/4/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//


import Foundation
import MapKit

class UserProfileAnnotation :NSObject,MKAnnotation{
    var coordinate =  CLLocationCoordinate2D()
    var latitude: Double
    var longitude:Double
     var title: String?
    var userId : String
   // var title : String!
   // var userName : String
   
    
   // init(coordinate :CLLocationCoordinate2D, userName : String){
       // self.coordinate = coordinate
      //  self.userName = userName
      
   // }
    init(latitude: Double, longitude: Double, userId : String, title : String) {
        self.latitude = latitude
        self.longitude = longitude
        //self.title = address
        self.userId = userId
        self.title = title
    }
}
