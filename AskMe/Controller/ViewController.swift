//
//  ViewController.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/13/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController{
 var menuShowing = false
    var reciverID : String!
    var email : String!
    var photURL : URL!
      @IBOutlet weak var leadingConstrains: NSLayoutConstraint!
      @IBOutlet weak var menuwidh: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    @IBAction func profile(_ sender: Any) {
        performSegue(withIdentifier: "DefineProfile", sender: "")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
   
    }
    @IBAction func MenuBarClick(_ sender: Any) {
        
        showMenuBar()
        
    }
    func showMenuBar(){
        if !menuShowing {
            leadingConstrains.constant = 0
            menuwidh.constant = 195
            menuShowing = true
        }
        else{
            leadingConstrains.constant = -155
            menuwidh.constant = 350
            menuShowing = false
        }
        
    }
    
    @IBOutlet weak var chat: CustomedButton!
    
    @IBAction func startChat(_ sender: Any) {
        self.performSegue(withIdentifier: "Searching", sender: "")

       
        
        }

    @IBAction func goToProfile(_ sender: Any) {
      self.performSegue(withIdentifier: "Profile", sender: "")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile"{
            if let destination = segue.destination as? ProfileViewController{
                
                
                destination.reciverID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                
            }
        }
        if segue.identifier == "Searching"{
            if let destination = segue.destination as? Searching{
                
              
                destination.reciverID = Auth.auth().currentUser?.uid
                destination.email = Auth.auth().currentUser?.email
                destination.photURL = Auth.auth().currentUser?.photoURL!
                
            }
        }
        
        
    }
}

