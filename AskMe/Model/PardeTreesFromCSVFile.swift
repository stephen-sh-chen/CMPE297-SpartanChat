//
//  PardeTreesFromCSVFile.swift
//  SmartStreetProject
//
//  Created by Maryam Jafari on 9/19/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
class PardeTreesFromCSVFile{
    var trees = [Tree]()
    
    func parsTreeCSV() -> [Tree] {
        var returnTrees = [Tree]()
        let path = Bundle.main.path(forResource: "Trees", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                var treeId : Int = 0
                var name : String = ""
                var barcode : String = ""
                var species : String = ""
                var lat : Double = 0.0
                var lon : Double = 0.0
                var age : Int = 0
                var desc : String = ""
                var city : String = ""
                
                if let id = row["id"]{
                    treeId = Int(id)!
                    
                }
                
                if let treeName = row ["identifier"]{
                    name = treeName
                    
                }
                if let treeBarcode = row ["barcode"]{
                    barcode = treeBarcode
                    
                }
                if let treeSpecies = row["species"]{
                    species = treeSpecies
                    
                }
                
                if let treeLat = row["lat"]{
                    lat = Double(treeLat)!
                    
                }
                if let treeLon = row["lon"]{
                    lon = Double(treeLon)!
                    
                }
                if let treeAge = row["age"]{
                    age = Int(treeAge)!
                }
                if let treeDescription = row["description"]{
                    desc = treeDescription
                }
                if let cityName = row["city"]{
                    city = cityName
                }
                
                let tree = Tree(name: name, treeId: treeId, barcode: barcode, species: species, age: age, latitude: lat, longtitude: lon, cityName: city, desc: desc)
                trees.append(tree)
                returnTrees = trees
                
            }
        }
        catch let err as NSError{
            print(err.debugDescription)
        }
        return returnTrees
    }
    func getTreeInfoFromBarcode(barcode : String)-> Tree{
        var returenedTree: Tree!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
                returenedTree = tree
            }
        }
        return returenedTree
    }
    func getCoordinateByBarcode(barcode: String)->( Double, Double){
        var coordinate: (Double, Double)!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
                coordinate = (tree.latitude,tree.lon)
            }
        }
        return coordinate
    }
    
    func getlongitudeByBarcode(barcode: String)->(Double){
        var lon: (Double)!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
                lon = (tree.latitude)
            }
        }
        return lon
    }
    
    func getlatitudeByBarcode(barcode: String)->(Double){
        var lat: (Double)!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
                lat = (tree.lon)
            }
        }
        return lat
    }
    
    
    
    func getTreeNameFromBarcode(barcode : String)-> String{
        var returenedTree: String!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
                returenedTree = tree.name
            }
        }
        return returenedTree
    }
    
    func getTreeIdFromBarcode(barcode : String)-> Int{
        var returenedTree: Int!
        var trees = [Tree]()
        trees = parsTreeCSV()
        for tree in trees{
            if tree.barcode == barcode{
               // returenedTree = tree.treeId
            }
        }
        return returenedTree
    }
}

