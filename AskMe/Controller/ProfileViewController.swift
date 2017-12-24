//
//  ProfileViewController.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/19/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import  FirebaseDatabase
import Firebase
import MapKit
import CoreLocation
import  GeoFire
class ProfileViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var major: UITextField!
    var reciverID : String!
    var email : String!
    var photURL : URL!
    var selectedRow: String!
    var newMajor : String!
    var newschoolYear : String!
    var newinterests : String!
    var newAddress: String!
    var long : Double!
    var lat : Double!
    var pickerData = ["Food","Transportation","Housing","Sell","Academic","Financial"]
    var newlocation : CLLocationCoordinate2D!

    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var cources: UITextField!
    @IBOutlet weak var interests: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var schoolYear: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var livesIn: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    func getCoordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        coordinates(forAddress: address) {
            (location) in
            self.newlocation = location
            guard location != nil else {
                print("Geocoding error")
                return
            }
        }
        completion(newlocation)

    }
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            self.lat = placemarks?.first?.location?.coordinate.latitude
            self.long = placemarks?.first?.location?.coordinate.longitude
            self.save()
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
       
        coordinates(forAddress: address.text!) { (location) in
           
        }
        }
    
    func save(){
        if let major = major.text{
            newMajor = major
            
        }
        if let interests = selectedRow {
            newinterests = interests
            
        }
        if let schoolYear = schoolYear.text{
            newschoolYear = schoolYear
            
        }
        if let address = address.text{
            newAddress = address
            
        }
            
       
            DBProvider.Instance.saveProfile(userId : reciverID, userdName: email, major : newMajor , interest: "Sell", schoolYear : newschoolYear, address : newAddress, Long: long,  lat: lat)
        
    }
    

    @IBAction func call(_ sender: Any) {
    }
    @IBAction func chat(_ sender: Any) {
        performSegue(withIdentifier: "ChatController", sender: reciverID)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatController"{
            if let destination = segue.destination as? Chat{
                if let id = sender as? String{
                    destination.reciverId = id
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text = email
        self.address.delegate = self
        self.major.delegate = self
        self.schoolYear.delegate = self
        let  imageURL = photURL
        let data = try? Data(contentsOf: imageURL!)
        self.image.image = UIImage(data: data!)!
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
     
        interests.delegate = self
        interests.dataSource = self
        
        major?.textColor = color
        schoolYear?.textColor = color
        address?.textColor = color
        DBProvider.Instance.getProfileDetailbyID(id : reciverID){(url) in
           
            self.major.text = url[0].major
            self.address.text = url[0].address
            self.schoolYear.text = url[0].year
            
        }
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func femaileRadioButton(_ sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBOutlet weak var maleRadioButton: UIButton!
    

    
    @IBAction func maleRadioButtonAction(_ sender: KGRadioButton) {
        sender.isSelected = !sender.isSelected
        
    }
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
     return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     return pickerData.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return pickerData[row]
     }
     
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
     
     }
     internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
     var pickerLabel: UILabel? = (view as? UILabel)
     if pickerLabel == nil {
     pickerLabel = UILabel()
     pickerLabel?.font = UIFont(name: "Avenir Next", size: 14.0)
     pickerLabel?.textAlignment = .center
     }
        pickerLabel?.text = pickerData[row]
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)

     pickerLabel?.textColor = color
     
     return pickerLabel!
     }
 
}

