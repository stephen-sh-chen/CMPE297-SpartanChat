//
//  TreeAnnotation.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/15/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import MapKit
public let trees = ["maryam.jafari@sjsu.edu","sanaz.khosravi@sjsu.edu","yueh-lin.lee@sjsu.edu","sih-han.chen@sjsu.edu"]
class TreeAnnotation :NSObject,MKAnnotation{
    var coordinate =  CLLocationCoordinate2D()
    var treeNumber : Int
    var treeName : String
    var title :String?
    
    init(coordinate :CLLocationCoordinate2D, treeNumber : Int){
        self.coordinate = coordinate
        self.treeName = trees[treeNumber-1].capitalized
        self.treeNumber = treeNumber
        self.title = self.treeName
    }
}

