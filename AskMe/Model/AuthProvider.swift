//
//  AuthProvider.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/26/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode{
    static let WRONG_PASSWORD = "WrongPassword"
    static let PROBLEM_CONNECTIBG = ""
    
}


class AuthProvider {
    private static let _instance = AuthProvider();
    private init(){}
    static var Instance : AuthProvider{
        return _instance
    }
    var username = ""
    
    func userID ()->String{
        return (Auth.auth().currentUser?.uid)!
    }
    func logIn(withEmail : String, password : String, loginHandler : LoginHandler?){
        Auth.auth().signIn(withEmail: withEmail   , password: password, completion :  { (user, error) in
            if error != nil {
                self.handleErrors(err : error! as NSError, loginHandler : loginHandler)
            }
            else{
                loginHandler?(nil)
            }
            
        });
    }
    
    func signUP(withEmail : String, password : String, loginHandler : LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail  , password: password, completion :  { (user, error) in
            if error != nil {
                self.handleErrors(err : error! as NSError, loginHandler : loginHandler)
            }
            else{
                if user?.uid != nil{
                 
                    self.logIn(withEmail: withEmail, password: password, loginHandler: loginHandler)
                }
            }
            
        });
    }
    func logOut() -> Bool{
    

       if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                return true
            }catch{
                return false
            }
        }
        return true
 
    }

    
    private func handleErrors(err : NSError, loginHandler : LoginHandler?){
        if let errcode = AuthErrorCode(rawValue: err.code){
            switch errcode{
            case .wrongPassword :
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            default :
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTIBG)
                break
            }
        }
    }
}

