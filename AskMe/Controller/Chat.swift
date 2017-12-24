//
//  Chat.swift
//  AskMe
//
//  Created by Maryam Jafari on 11/24/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import  AVKit
import FirebaseAuth
import SDWebImage
import FirebaseDatabase
import FirebaseStorage
import PubNub

//MessageRecievedDelegate
class Chat: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PNObjectEventListener {
     var reciverId : String!
     var ReciverName: String!
     var avatarDictionary: [String:UIImage] = [:]

     let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
     var roomName : String!
     
     private var messages = [JSQMessage]()
     let picker = UIImagePickerController()
     override func viewDidLoad() {
          super.viewDidLoad()
          self.senderId = AuthProvider.Instance.userID()
         // MessageHandler.Instace.delegate = self
          self.senderDisplayName = AuthProvider.Instance.username
          picker.delegate = self
          //MessageHandler.Instace.observeMessages()
         // MessageHandler.Instace.observeMediaMessages()

          observeMessages()
          observeMediaMessages()
          //collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
         // collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
          appDelegate.client.addListener(self)
          // Subscribe to demo channel with presence observation
          appDelegate.client.subscribeToChannels(["my_channel"], withPresence: true)
     
     }
   
     // chat control
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
          return messages[indexPath.item]
     }
   
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
          let msg = messages[indexPath.item]
          if msg.isMediaMessage{
               if let mediaItem = msg.media as? JSQVideoMediaItem{
                    let player = AVPlayer(url: mediaItem.fileURL)
                    let playerController = AVPlayerViewController();
                    playerController.player = player
                    self.present(playerController, animated: true, completion: nil)
               }
          }
     }
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return messages.count
     }
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
          return cell
     }
     override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
          //MessageHandler.Instace.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text, reciverID: reciverId!)
           self.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text, reciverID: reciverId!)
              finishSendingMessage()
          collectionView.reloadData()

      
     }
     
     override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
          let bubbleFactorty = JSQMessagesBubbleImageFactory()
          let mesage = messages[indexPath.item]
          if (mesage.senderId == self.senderId){
               return bubbleFactorty?.outgoingMessagesBubbleImage(with: UIColor.blue)
          }
          else{
               return bubbleFactorty?.incomingMessagesBubbleImage(with: UIColor.gray)
          }
     }
 override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
  

  

     return nil
     }
     
     
     
     
  
   
     override func didPressAccessoryButton(_ sender: UIButton!) {
          let alert = UIAlertController(title: "Media Messages", message: "Please Select A Media", preferredStyle: .actionSheet)
          let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
          let photos = UIAlertAction(title: "Photos", style: .default, handler: {(alert : UIAlertAction) in
               self.chooseMedia(type: kUTTypeImage)
               
          })
          let videos = UIAlertAction(title: "Videos", style: .default, handler: {(alert : UIAlertAction) in
               self.chooseMedia(type: kUTTypeMovie)
          })
          alert.addAction(photos)
          alert.addAction(cancel)
          alert.addAction(videos)
          present(alert, animated: true, completion: nil)
     }
     // picker view function
     private func chooseMedia(type : CFString){
          picker.mediaTypes = [type as String]
          present(picker, animated: true, completion : nil)
     }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
          if let pic = info[UIImagePickerControllerOriginalImage] as?
               UIImage{
               let data = UIImageJPEGRepresentation(pic, 0.01)
               // MessageHandler.Instace.sendMedia(image: data, video: nil, senderId: senderId, senderName: senderDisplayName)
               sendMedia(image: data, video: nil, senderId: senderId, senderName: senderDisplayName, reciverID: reciverId)
                finishSendingMessage()
               
          }
          else if let vidURL = info[UIImagePickerControllerMediaURL] as? URL{
               // MessageHandler.Instace.sendMedia(image: nil, video: vidURL , senderId: senderId, senderName: senderDisplayName)
               
               sendMedia(image: nil, video: vidURL , senderId: senderId, senderName: senderDisplayName, reciverID: reciverId)
                finishSendingMessage()
          }
          
          self.dismiss(animated: true, completion: nil)
          collectionView.reloadData()
     }
    //chat methods
     func sendMessage(senderID : String, senderName : String, text: String, reciverID : String){
          let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderID, Constant.SENDER_NAME : senderName, Constant.TEXT : text, Constant.RECIVER_ID : reciverID]
          DBProvider.Instance.messageRef.childByAutoId().setValue(data)
     }
     private func addMessage(withId id: String, name: String, text: String, reciverID : String) {
          
         let uid = Auth.auth().currentUser?.uid
          print ("uid \(uid!)")
          if (reciverID == uid! || id == uid!){
               if(reciverId == reciverID || reciverId == id)
               {
                    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                         messages.append(message)
                    }
               }
          }
     }
     func observeMessages(){
          DBProvider.Instance.messageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
               if let data = snapshot.value as? NSDictionary {
                    if let senderID = data[Constant.SENDER_ID] as? String{
                         if let senderName = data[Constant.SENDER_NAME] as? String{
                              if let text = data[Constant.TEXT] as? String{
                                   if let reciverID = data[Constant.RECIVER_ID] as? String{
                                        self.addMessage(withId: senderID, name: senderName, text: text, reciverID: reciverID)
                                        self.finishReceivingMessage()
                                   }
                              }
                         }
                    }
               }
          }
     }
     // media methods

     func mediaRecived(senderID: String, senderName: String, url: String, reciverID : String) {
          if let mediaURL = URL(string : url)
          {
               do {
                    let data = try Data(contentsOf : mediaURL)
                    if let _ = UIImage(data :  data){
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                         DispatchQueue.main.async {
                              let photo = JSQPhotoMediaItem(image: image)
                              if senderID == self.senderId{
                                   photo?.appliesMediaViewMaskAsOutgoing = true
                              }
                              else
                              {
                                   photo?.appliesMediaViewMaskAsOutgoing = false

                              }
                              if (reciverID == Auth.auth().currentUser?.uid || senderID == Auth.auth().currentUser?.uid){
                                   if(self.reciverId == reciverID || self.reciverId == senderID)
                                   {
                              self.messages.append(JSQMessage(senderId: senderID, senderDisplayName: senderName, date: Date(), media: photo))
                                   }
                              }
                              self.collectionView.reloadData()
                         }
                    })
               }
                    else{
                         let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                         
                         
                         if senderID == self.senderId{
                              video?.appliesMediaViewMaskAsOutgoing = true
                         }
                         else
                         {
                              video?.appliesMediaViewMaskAsOutgoing = false
                              
                         }
                         if (reciverID == Auth.auth().currentUser?.uid || senderID == Auth.auth().currentUser?.uid){
                              if(self.reciverId == reciverID || self.reciverId == senderID)
                              {
                         self.messages.append(JSQMessage(senderId: senderID, senderDisplayName: senderName, date: Date(), media: video))
                              }
                              
                         }
                         self.collectionView.reloadData()
                         
               }
               }
               catch{
                    
               }
          }
     }
     
     
     
     
     func sendMedia(image: Data?, video: URL? ,senderId : String, senderName: String, reciverID : String){
          if image != nil{
               DBProvider.Instance.imageStorageRef.child(senderId + "\(NSUUID().uuidString).jpg").putData(image!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                    in
                    if err != nil{
                         
                    }
                    else{
                      //   self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!))
                         self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!), reciverID: reciverID)
                    }
               }
          }else{
               DBProvider.Instance.videoStorageRef.child(senderId + "\(NSUUID().uuidString)").putFile(from: video!, metadata: nil){(metadata : StorageMetadata?, err : Error?)
                    in
                    if err != nil{
                         
                    }
                    else{
                       //  self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!))
                       self.sendMediaMessage(senderId: senderId, senderName: senderName, url: String(describing : metadata!.downloadURL()!), reciverID: reciverID)
                    }
               }
          }
     }
     func sendMediaMessage(senderId: String, senderName : String, url : String, reciverID : String){
          let data : Dictionary<String, Any> = [Constant.SENDER_ID : senderId, Constant.SENDER_NAME : senderName, Constant.URL : url,  Constant.RECIVER_ID : reciverID]
          DBProvider.Instance.mediamessageRef.childByAutoId().setValue(data)
          
     }
     
   /*  func messageRecived(messageID: String, senderID: String, senderName : String, text: String, recieverID : String){
          
         // var array = [String]()
          //array = MessageHandler.Instace.getMessageIds()
       
         // for id in array{
              // if id == messageID{
                    
        
          if (recieverID == Auth.auth().currentUser?.uid || senderID == Auth.auth().currentUser?.uid){
               if(reciverId == recieverID || reciverId == senderID)
               {
              
                    messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text))
                    
               
                     finishReceivingMessage()
               }
               
          }
         // }
         // }
     }
     
     */
     
     
     func observeMediaMessages(){
          DBProvider.Instance.mediamessageRef.observe(DataEventType.childAdded) { (snapshot : DataSnapshot) in
               if let data = snapshot.value as? NSDictionary {
                    if let id = data[Constant.SENDER_ID] as? String{
                         
                         if let name = data[Constant.SENDER_NAME] as? String{
                              if let fileURL = data[Constant.URL] as? String{
                                   if let reciverID = data[Constant.RECIVER_ID] as? String{
                                        //self.delegate?.mediaRecived( senderID: id,senderName: name, url: fileURL, reciverID: reciverID)
                                       self.mediaRecived( senderID: id,senderName: name, url: fileURL, reciverID: reciverID)
                                        self.finishReceivingMessage()
                                   }
                              }
                         }
                    }
               }
               
          }}
 
    @IBAction func openAudioChat(_ sender: Any) {
        
    }
    @IBAction func openVideoChat(_ sender: Any) {
          let uuid = UUID().uuidString
          appDelegate.client.publish(uuid, toChannel: "my_channel", compressed: false, withCompletion: nil)
     }
     
     //func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
     //     print (message)
     //}
     
     func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
          
          // Handle new message stored in message.data.message
          if message.data.channel != message.data.subscription {
               
               // Message has been received on channel group stored in message.data.subscription.
          }
          else {
               
               // Message has been received on channel stored in message.data.channel.
          }
          
          print("Received message: \(message.data.message) on channel \(message.data.channel) " +
               "at \(message.data.timetoken)")
          self.roomName = message.data.message as! String
          let alert = UIAlertController(title: "Video Chat", message: roomName, preferredStyle: UIAlertControllerStyle.alert)
          
          alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
               self.performSegue(withIdentifier: "ToVideoChatView", sender: self.roomName)
          }))
          
          
          self.present(alert, animated: true, completion: nil)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "ToVideoChatView"{
               if let destination = segue.destination as? RTCVideoChatViewController {
                    destination.roomName = self.roomName as! NSString
                    //destination.roomUrl = "https://appr.tc/r/" + self.roomName
               }
          }
     }
     
     

     
     @IBAction func exit(_ sender: Any) {
          dismiss(animated: true, completion: nil)
     }
     
     
}

