//
//  MessageHandler.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/26/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol MessageRecievedDelegate : class {
   // func messageRecived(messageID : String, senderID: String, senderName : String, text: String, recieverID : String)
    // func mediaRecived( senderID: String, senderName : String, url: String, reciverID : String)
}
class MessageHandler{
    private  static let _instance = MessageHandler()
    private init(){}
    weak var delegate : MessageRecievedDelegate?
    static var Instace : MessageHandler{
        return _instance
    }
  /*  func sendMessage(senderID : String, senderName : String, text: String, reciverID : String){
        let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderID, Constant.SENDER_NAME : senderName, Constant.TEXT : text, Constant.RECIVER_ID : reciverID]
        DBProvider.Instance.messageRef.childByAutoId().setValue(data)
    }
    
 
    func sendMediaMessage(senderId: String, senderName : String, url : String){
        let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderId, Constant.SENDER_NAME : senderName, Constant.URL : url]
        DBProvider.Instance.mediamessageRef.childByAutoId().setValue(data)
        
    }*/
   /* func sendMedia(image: Data?, video: URL? ,senderId : String, senderName: String){
        if image != nil{
            DBProvider.Instance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                in
                if err != nil{
                    
                }
                else{
                    self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!))
                }
            }
        }else{
            DBProvider.Instance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                in
                if err != nil{
                    
                }
                else{
                    self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!))
                }
        }
    }
    }*/
  /*  func observeMediaMessages(){
        DBProvider.Instance.mediamessageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let id = data[Constant.SENDER_ID] as? String{
                    
                    if let name = data[Constant.SENDER_NAME] as? String{
                        if let fileURL = data[Constant.URL] as? String{
                          if let reciverID = data[Constant.RECIVER_ID] as? String{
                             self.delegate?.mediaRecived( senderID: id,senderName: name, url: fileURL, reciverID: reciverID)
                        
                     }
                    }
                    }
                }
            }
            
        }
    }*/
   /* func observeMessages(){
        DBProvider.Instance.messageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let senderID = data[Constant.SENDER_ID] as? String{
                    
                    if let senderName = data[Constant.SENDER_NAME] as? String{
                        if let text = data[Constant.TEXT] as? String{
                            if let reciverID = data[Constant.RECIVER_ID] as? String{
                                self.delegate?.messageRecived(messageID : snapshot.key ,senderID: senderID,senderName: senderName, text: text, recieverID : reciverID)
                            }
                        }
                    }
                }
            }
        }
    }*/
}

