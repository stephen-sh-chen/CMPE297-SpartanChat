	//
//  Searching.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/13/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import  FirebaseAuth
//, UIPickerViewDataSource, UIPickerViewDelegate,
    class Searching: UIViewController,  UITableViewDelegate, UITableViewDataSource, FetchData, UISearchBarDelegate{
     var menuShowing = false
        @IBOutlet weak var leadingConstrains: NSLayoutConstraint!
        @IBOutlet weak var menuwidh: NSLayoutConstraint!
    var reciverID : String!
    var email : String!
    var photURL : URL!
    var inSearchableMode = false
    var newProfile = [Profile]()
    var filterProfile = [Profile]()
    private var profiles = [Profile]()
    var pickerData : [String] = [String]()

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var categoryPicker: UIPickerView!
        
        @IBOutlet weak var profileimage: UIButton!
        override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
        
  self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:color]
      
        let textcolor = UIColor(red:0.76, green:0.34, blue:0.0, alpha:1.0)
             name.text = email
            name?.textColor = textcolor

            let data = try? Data(contentsOf: photURL!)
            let image: UIImage = UIImage(data: data!)!
         
            profileimage.setImage(image, for: .normal)
       // categoryPicker.delegate = self
        //categoryPicker.dataSource = self
        table.delegate = self
        table.dataSource = self
        DBProvider.Instance.delegate = self
        DBProvider.Instance.getProfiles()
        searchbar.delegate = self
        searchbar.returnKeyType = UIReturnKeyType.done
        
        
        //getting profils from data base
        
        
        pickerData = ["Food","Transportation","Housing","Sell","Academic","Financial"]
    }
        
     
        @IBAction func profileClick(_ sender: Any) {
            performSegue(withIdentifier: "Profile", sender: "")

        }
        
    @IBAction func SearchOnMap(_ sender: Any) {
        performSegue(withIdentifier: "Map", sender: reciverID)

        
    }
    func dataRecieved(contacts : [Profile]){
        self.profiles = contacts
        for contact in contacts{
            if contact.id == AuthProvider.Instance.userID(){
                AuthProvider.Instance.username = contact.name
            }
        }
        for profile in profiles{
            if (profile.id != Auth.auth().currentUser?.uid ){
                newProfile.append(profile)
            }
        }
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        func showMenuBar(){
            if !menuShowing {
                leadingConstrains.constant = 0
                menuwidh.constant = 231
                menuShowing = true
            }
            else{
                leadingConstrains.constant = -231
                menuwidh.constant = 350
                menuShowing = false
            }
            
        }
        @IBAction func MenuBarClick(_ sender: Any) {
            
            showMenuBar()
            
        }
    
  /*  func numberOfComponents(in pickerView: UIPickerView) -> Int {
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
            pickerLabel?.font = UIFont(name: "Papyrus", size: 14.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerData[row]
        pickerLabel?.textColor = UIColor.brown
        
        return pickerLabel!
    }
 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(inSearchableMode){
             return filterProfile.count
        }
        return newProfile.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProfileCell
        var profile : Profile!
       
        
        if (inSearchableMode){
             profile = filterProfile[indexPath.row]
            DBProvider.Instance.getProfilesImages(userId: profile.id){(url ) in
                profile.imageURl = url
            }
      
        }
        else{
           profile = newProfile[indexPath.row]
            DBProvider.Instance.getProfilesImages(userId: profile.id){(url ) in
                profile.imageURl = url
            }
            
        }
        cell?.configureCell(profile:profile)
        return cell!;
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text == nil || searchBar.text == ""){
            inSearchableMode = false
         table.reloadData()
            //view.endEditing(true)
        }
        else{
            inSearchableMode = true
            let lower = searchBar.text!.lowercased()
            filterProfile = newProfile.filter({$0.name.range(of: lower) != nil})
            table.reloadData()
            
            
        }
    }
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
       navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "Profile", sender: newProfile[indexPath.row].id)
         performSegue(withIdentifier: "Chat", sender: newProfile[indexPath.row].id)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == "Profile"{
            if let destination = segue.destination as? ProfileViewController{
                
                
                destination.reciverID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                
            }
        }
        if segue.identifier == "Map"{
            if let destination = segue.destination as? Map{
                if let id = sender as? String{
                   // destination.reciverID = id
                }
            }
        }
        if segue.identifier == "Chat"{
            if let destination = segue.destination as? Chat{
                if let id = sender as? String{
                    destination.reciverId = id
                }
            }
        }
        
    }
    
    
}

