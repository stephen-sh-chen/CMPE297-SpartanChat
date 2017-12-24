//
//  Login.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/23/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class Login: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
      

    
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("User is signed in")
            print("user id is: " + authentication.idToken)
            print("access token is: " + authentication.accessToken)
            let user = Auth.auth().currentUser
            if let user = user {
                
                let uid = user.uid
                let email = user.email
               // let photoUrl = user.photoURL
                
                print("uid is: " + uid)
                print("email is: " + email!)
                
            }
            let url = Auth.auth().currentUser?.photoURL!
           // DBProvider.Instance.saveUser(withID: user!.uid, email: userName.text!, password: pass.text)
           // DBProvider.Instance.saveUser(withID: user!.uid, email : (user?.email)!)
            DBProvider.Instance.saveUser(withID: user!.uid, email : (user?.email)!, photoURL : String(describing: url!))
         
            self.performSegue(withIdentifier: "Searching", sender: "")
            
           
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Searching"{
            if let destination = segue.destination as? Searching{
              
                    
                    destination.reciverID = Auth.auth().currentUser?.uid
                    destination.email = Auth.auth().currentUser?.email
                    destination.photURL = Auth.auth().currentUser?.photoURL!
            
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    @IBOutlet weak var signUp: UIButton!
 
    @IBAction func signUpClick(_ sender: Any) {
       
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.signUP(withEmail: userName.text!, password: pass.text!, loginHandler: { (message) in
                
                if message != nil  {
                    self.alertTheUser(title: "Problem With Creating User", message: message!)
                }
                else{
                 
                  //  self.userName.text = ""
                    //self.pass.text = ""
                   // self.performSegue(withIdentifier: "LogedIn", sender: self.userName.text)
                }
            })
        }
        
        
    }
    @IBOutlet weak var login: UIButton!
    @IBAction func logInClick(_ sender: Any) {
        if userName.text != "" && pass.text != ""{
            AuthProvider.Instance.logIn(withEmail: userName.text!, password: pass.text!, loginHandler: { (message) in
                if message != nil {
                   
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                }
                else{
                    self.userName.text = ""
                    self.pass.text = ""
                    self.performSegue(withIdentifier: "LogedIn", sender: self.userName.text)
                }
            })
        }
        
    }
    private func alertTheUser(title : String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction (title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
   

}
