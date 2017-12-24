    //
    //  DBProvider.swift
    //  AskMe
    //
    //  Created by Maryam Jafari on 11/24/17.
    //  Copyright © 2017 Maryam Jafari. All rights reserved.
    //
    
    import Foundation
    import FirebaseDatabase
    import FirebaseStorage
    protocol FetchData : class{
        func dataRecieved (contacts : [Profile]);
         
    }
    
    
    class DBProvider {
        private static let _instance = DBProvider();
        weak var delegate : FetchData?
        private init(){}
        static var Instance : DBProvider{
            return _instance
        }
        var dbRef : DatabaseReference {
            return Database.database().reference()
        }
        var contactsRef : DatabaseReference{
            return dbRef.child(Constant.PROFILE)
        }
          var profileDetailRef : DatabaseReference{
            return dbRef.child(Constant.PROFILEDETAIL)
        }
        var messageRef : DatabaseReference{
            return dbRef.child(Constant.MESSAGES)
        }
        var mediamessageRef : DatabaseReference{
            return dbRef.child(Constant.MEDIA_MESSEGES)
        }
        var storageRef : StorageReference{
            return Storage.storage().reference(forURL: "gs://askme-e0182.appspot.com")
        }
        var imageStorageRef : StorageReference{
            return storageRef.child(Constant.IMAGE_STORAGE)
        }
        var videoStorageRef : StorageReference{
            return storageRef.child(Constant.VIDEO_STORAGE)
        }
        // add what ever you need to save in DB
        
        func getProfileDetail(completion: @escaping ([ProfileDetail]) -> Void){
            
            // getting profils from data base to show in searching
            profileDetailRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                var contacts = [ProfileDetail]()
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        if let contactData = value as?NSDictionary{
                            if let email = contactData[Constant.SJSUEMAIL] as? String {
                                let id = key as! String
                                let userId = contactData[Constant.USERID] as? String
                                 let address = contactData[Constant.ADDRESS] as? String
                                 let interest = contactData[Constant.INTEREST] as? String
                                 let schoolYear = contactData[Constant.SCHOOL_YEAR] as? String
                                if let long = contactData[Constant.LONGTITUDE] as? Double{
                                    if  let lat = contactData[Constant.LANGTITUDE] as? Double{
                                 let major = contactData[Constant.MAJOR] as? String
                                        let newContact = ProfileDetail(address: address!, interest: interest!, schoolYear: schoolYear!, major: major!, userid: userId!, userEmail: email, latitude: lat, longtitude: long)
                                //let newContact = Profile(name: email, id: id, imageURL: image! )
                                contacts.append(newContact)
                                        
                                
                            }
                                   
                            }
                            }
                        }
                        
                    }
                     completion(contacts as [ProfileDetail]! )
                }
               
            }
            
        }
        
        func getProfileDetailbyID(id : String, completion: @escaping ([ProfileDetail]) -> Void){
            
            // getting profils from data base to show in searching
            profileDetailRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                var contacts = [ProfileDetail]()
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        let id1 = key as! String
                        if (id1 == id){
                        if let contactData = value as?NSDictionary{
                            if let email = contactData[Constant.SJSUEMAIL] as? String {
                                
                                let userId = contactData[Constant.USERID] as? String
                                let address = contactData[Constant.ADDRESS] as? String
                                let interest = contactData[Constant.INTEREST] as? String
                                let schoolYear = contactData[Constant.SCHOOL_YEAR] as? String
                                if let long = contactData[Constant.LONGTITUDE] as? Double{
                                    if  let lat = contactData[Constant.LANGTITUDE] as? Double{
                                        let major = contactData[Constant.MAJOR] as? String
                                        let newContact = ProfileDetail(address: address!, interest: interest!, schoolYear: schoolYear!, major: major!, userid: userId!, userEmail: email, latitude: lat, longtitude: long)
                                        //let newContact = Profile(name: email, id: id, imageURL: image! )
                                        contacts.append(newContact)
                                        
                                        
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    }
                    completion(contacts as [ProfileDetail]! )
                }
                
            }
            
        }
        
        func getProfiles(){
            
            // getting profils from data base to show in searching
            contactsRef.observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                var contacts = [Profile]()
                if let mycontacts = snapshot.value as? NSDictionary{
                    for (key, value) in mycontacts{
                        if let contactData = value as?NSDictionary{
                            if let email = contactData[Constant.EMAIL] as? String {
                                let id = key as! String
                                let imageUrl = contactData[Constant.PHOTO_URL] as? String
                                let newContact = Profile(name: email, id: id, imageURL: imageUrl!)
                                 //let newContact = Profile(name: email, id: id, imageURL: image! )
                                contacts.append(newContact)
                                
                            }
                        }
                        
                    }
                }
                self.delegate?.dataRecieved(contacts: contacts)
            }
            
        }
        
        
        
        func updateAddresslong(userId : String, long : Double){
        
        let ref = profileDetailRef.child(userId)
        
        ref.updateChildValues([
        Constant.LONGTITUDE: long
        ])
        
        }
        func updateAddresslat(userId : String, long : Double){
            
            let ref = profileDetailRef.child(userId)
            
            ref.updateChildValues([
                Constant.LANGTITUDE: long
                ])
            
        }
        
        func getProfilesImages(userId : String, completion: @escaping (String) -> Void) {
            
            let rootRef = Database.database().reference()
            rootRef.child(Constant.PROFILE).observeSingleEvent(of: .value) {
                (snapshot: DataSnapshot) in
                if snapshot.key == userId{
                if let postsDictionary = snapshot .value as? [String: AnyObject] {
                for post in postsDictionary {
                    let messages = post.value as! [String: AnyObject]
                    for (key, value) in messages {
                        if key == Constant.PHOTO_URL{
                            
                            completion(value as! String)
                        }
                        
                    }
                    
                }
                }
            }
                
            }
           
         
        }
        
        func getAddressByUserID(userId : String, completion: @escaping (String) -> Void) {
            
            let rootRef = Database.database().reference()
            rootRef.child(Constant.PROFILEDETAIL).observeSingleEvent(of: .value) {
                (snapshot: DataSnapshot) in
                //if snapshot.userId == userId{
                    if let postsDictionary = snapshot .value as? [String: AnyObject] {
                        for post in postsDictionary {
                            let messages = post.value as! [String: AnyObject]
                            for (key, value) in messages {
                                if key == Constant.ADDRESS{
                                    
                                    completion(value as! String)
                                }
                                
                            }
                            
                        }
                    
                }
                
            }
            
            
        }
        
      
        func saveUser (withID : String,email : String, password: String){
            let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : password]
            contactsRef.child(withID).setValue(data)
        }
        func saveUser (withID : String, email : String,  photoURL: String){
            let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : "", Constant.PHOTO_URL: photoURL]
            contactsRef.child(withID).setValue(data)
        }
        func saveUser (withID : String, email : String){
            let data : Dictionary<String, Any> = [Constant.EMAIL : email, Constant.PASSWORD : ""]
            contactsRef.child(withID).setValue(data)
        }
        func saveProfile (userId : String, userdName: String, major : String, interest: String, schoolYear : String, address : String, Long : Double, lat : Double){
            let data : Dictionary<String, Any> = [Constant.USERID : userId, Constant.SJSUEMAIL  : userdName,Constant.MAJOR : major, Constant.INTEREST : interest, Constant.SCHOOL_YEAR : schoolYear, Constant.ADDRESS : address, Constant.LONGTITUDE : Long, Constant.LANGTITUDE : lat]
            profileDetailRef.child(userId).setValue(data)
           
        }
    }

