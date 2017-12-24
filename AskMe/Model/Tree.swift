//
//  Tree.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/12/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation

class Tree{
    
    private var _name : String!
    private var _treeId : Int!
    private var _barcode : String!
    private var _age : Int!
    private var _species : String!
    private var _latitude : Double!
    private var _lon : Double!
    private var _area : String!
    private var _treeDescription : String!
    
    var name : String{
        return _name
    }
    var treeId : Int{
        return _treeId
    }
    var barcode : String{
        return _barcode
    }
    var species : String{
        return _species
    }
    var age : Int{
        return _age
    }
    var latitude : Double{
        return _latitude
    }
    var lon : Double{
        return _lon
    }
    var area : String{
        return _area
    }
    var treeDescription : String{
        return _treeDescription
    }
    
    init(name : String, treeId : Int, barcode : String, species: String, age : Int,
         latitude : Double, longtitude : Double, cityName : String, desc : String ) {
        self._barcode = barcode
        self._name = name
        self._treeId = treeId
        self._species = species
        self._age = age
        self._latitude = latitude
        self._lon = longtitude
        self._area = cityName
        self._treeDescription = desc
    }
    func getCoordinateByTreeId(treeId: Int)->(latitude: Double, longtitud: Double){
        return (_latitude, _lon)
        
    }
    func getTreeNameFromBarcode(barcode : String)-> String{
        return _name
    }
    
    
    
}
//
//  Tree.swift
//  AskMe
//
//  Created by Maryam Jafari on 12/8/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
