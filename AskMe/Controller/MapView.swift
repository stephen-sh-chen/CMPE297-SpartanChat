//
//  Map.swift
//  AskMe
//
//  Created by Maryam Jafari on 12/4/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
 
 import UIKit
 import MapKit
 import FirebaseDatabase
 import StoreKit
 import  GeoFire
 
 
 class MapView: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
 func dataRecieved(contacts: [Profile]) {
 
 }
 
 var newAddress: String!
 var username : String!
 var reciverID : String!
 let locationManager = CLLocationManager()
 var mapHasCenterOnce = false
 var geoFire: GeoFire!
 var geoFireRef : DatabaseReference!
 var nearByUser : ProfileDetail!
 var users = [ProfileDetail]()
 var newProfileDetail = [ProfileDetail]()
 var gettingUserId :String!
 var annotation: UserProfileAnnotation?
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 map.delegate = self
 
 map.userTrackingMode = MKUserTrackingMode.follow
 geoFireRef = Database.database().reference()
 geoFire = GeoFire(firebaseRef: geoFireRef)
 
 
 locationManager.delegate = self
 locationManager.desiredAccuracy = kCLLocationAccuracyBest
 locationManager.requestWhenInUseAuthorization()
 //locationManager.startUpdatingLocation()
 self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
 /* DBProvider.Instance.getProfileDetail(){(url) in
 self.users = url
 for user in self.users{
 if (user.address != ""){
 self.newProfileDetail .append(user)
 }
 for user in self.newProfileDetail{
 let loc = CLLocation(latitude: user.latitude , longitude: user.lon)
 
 self.createSighting(forLocation:loc , usrId: user.userId)}
 
 }
 
 }*/
 let annotation1 = UserProfileAnnotation( latitude: 37.3107667, longitude: -121.8790299, userId: "xyWqDBpkU7fTFYjLPCN9sJyimCC3", title : "xyWqDBpkU7fTFYjLPCN9sJyimCC3")
 let annotation2 = UserProfileAnnotation( latitude: 37.8001988, longitude: -122.401738, userId: "kjsd", title : "ndb")
 map.addAnnotation(annotation1)
 map.addAnnotation(annotation2)
 getUserProfile() { (profiles) in
 for user in self.newProfileDetail{
 let loc = CLLocation(latitude: user.latitude , longitude: user.lon)
 
 // self.createSighting(forLocation:loc , usrId: user.userId)
 self.map.showAnnotations(self.map.annotations, animated: true)
 
 self.centerMapOnLocation(location: loc)
 // self.showSightingOnMap(location: loc, completion: user.userId)
 }
 }
 map.addAnnotations([annotation1, annotation2])
 
 //  self.annotation = UserProfileAnnotation( latitude: 37.3107667, longitude: -121.8790299, userId: "gfg")
 
 // DispatchQueue.main.async {
 //  map.addAnnotation(self.annotation!)
 // map.showAnnotations(self.map.annotations, animated: true)
 // self.centerMapOnLocation(location: location)
 
 }
 
 func getUserProfile(completion: @escaping ([ProfileDetail]?) -> Void) {
 
 DBProvider.Instance.getProfileDetail(){(url) in
 self.users = url
 for user in self.users{
 if (user.address != ""){
 self.newProfileDetail .append(user)
 }
 
 }
 completion(self.newProfileDetail)
 
 }
 }
 @IBOutlet weak var map: MKMapView!
 func changeCoordinate(){
 
 for user in newProfileDetail{
 
 
 
 let loc = CLLocation(latitude: user.latitude, longitude: user.lon)
 let coordinateRegion = MKCoordinateRegionMakeWithDistance(loc.coordinate, 2000, 2000)
 map.setRegion(coordinateRegion, animated: true)
 }
 
 
 
 }
 /* func setUserSpot() {
 
 
 for user in newProfileDetail{
 let loc = CLLocation(latitude: user.latitude , longitude: user.lon)
 
 createSighting(forLocation: loc, usrId: usr.userid)
 }
 }*/
 
 func centerMapOnLocation(location: CLLocationCoordinate2D){
 let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, 90000, 90000)
 map.setRegion(coordinateRegion, animated: true)
 }
 func coordinates(forAddress address: String, completion: @escaping (CLLocation?) -> Void) {
 let geocoder = CLGeocoder()
 geocoder.geocodeAddressString(address) {
 (placemarks, error) in
 guard error == nil else {
 print("Geocoding error: \(error!)")
 completion(nil)
 return
 }
 completion(placemarks?.first?.location)
 }
 }
 func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
 //if let anno = view.annotation as? UserProfileAnnotation{
 //  let place = MKPlacemark(coordinate: anno.coordinate)
 performSegue(withIdentifier: "ChatFromMap", sender:"")
 //}
 //  if (view.annotation as? UserProfileAnnotation) != nil{
 // let v = view.annotation as? UserProfileAnnotation
 // gettingUserId = v?.userId
 
 
 // }
 }
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
 if segue.identifier == "ChatFromMap"{
 if let destination = segue.destination as? Chat{
 
 
 destination.reciverId = ""
 
 }
 }
 }
 func locationAuthStatus(){
 if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
 map.showsUserLocation = true
 }
 else{
 locationManager.requestWhenInUseAuthorization()
 
 }
 }
 func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 if status == .authorizedWhenInUse{
 map.showsUserLocation = true
 }
 }
 func centerMapOnLocation(location: CLLocation){
 let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
 
 map.setRegion(coordinateRegion, animated: true)
 }
 
 func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
 if let loc = userLocation.location{
 if !mapHasCenterOnce{
 centerMapOnLocation(location: loc)
 mapHasCenterOnce = true
 }
 }
 
 changeCoordinate()
 
 }
 override func viewWillAppear(_ animated: Bool) {
 locationManager.startUpdatingLocation()
 }
 func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
 // var annotaionView : MKAnnotationView?
 /* let annoIdentifire = "UserProfile"
 
 //if annotation.isKind(of: MKUserLocation.self){
 //  annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
 //  annotaionView?.image = UIImage(named: "icons8-User Location-40")
 //  }
 //else
 if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifire){
 annotaionView = deqAnno
 annotaionView?.annotation = annotation
 }
 else {
 let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifire)
 av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
 annotaionView = av
 }
 if let annotationView = annotaionView{
 annotaionView?.canShowCallout = true
 annotationView.image = UIImage(named: "icons8-User Location-40")
 let btn = UIButton()
 
 btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
 
 btn.setImage(UIImage(named: "icons8-User Location-40"), for: .normal)
 
 
 annotaionView?.rightCalloutAccessoryView = btn
 }
 return annotaionView*/
 var annotationView : MKAnnotationView?
 let annoIdentifire = "UserProfile"
 if annotation.isKind(of: MKUserLocation.self){
 annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
 annotationView?.image = UIImage(named: "icons8-User Location-40")
 }
 else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifire){
 annotationView = deqAnno
 annotationView?.annotation = annotation
 }
 else {
 let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifire)
 av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
 annotationView = av
 }
 if let annotationView = annotationView{
 //, let _ = annotation as? UserProfileAnnotation{
 annotationView.canShowCallout = true
 annotationView.image = UIImage(named: "icons8-google-maps-40")
 let btn = UIButton()
 
 btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
 
 btn.setImage(UIImage(named: "icons8-google-maps-40"), for: .normal)
 
 
 annotationView.rightCalloutAccessoryView = btn
 
 }
 return annotationView
 }
 
 override func viewDidAppear(_ animated: Bool) {
 locationAuthStatus()
 
 }
 
 func createSighting(forLocation location: CLLocation, usrId userID : String){
 geoFire.setLocation(location, forKey: "\(userID)")
 showSightingOnMap(location: location){(key, newLoc) in
 self.annotation = UserProfileAnnotation( latitude: newLoc.coordinate.latitude, longitude: newLoc.coordinate.longitude, userId: key, title : userID)
 
 // DispatchQueue.main.async {
 self.map.addAnnotation(self.annotation!)
 
 //}
 }
 }
 
 func showSightingOnMap(location :CLLocation, completion: @escaping (String, CLLocation) -> Void){
 let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
 _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
 
 if let key = key, let location = location {
 
 completion(key,location)
 
 
 }
 
 }
 )
 
 
 }
 
 func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
 for user in newProfileDetail{
 let loc = CLLocation(latitude: user.latitude , longitude: user.lon)
 /*  showSightingOnMap(location: loc){(key, newLoc) in
 let anno = UserProfileAnnotation( latitude: newLoc.coordinate.latitude, longitude: newLoc.coordinate.longitude, userId: key)
 
 // DispatchQueue.main.async {
 self.map.addAnnotation(anno)
 self.map.showAnnotations(self.map.annotations, animated: true)
 
 //}
 }
 */
 }
 }
 
 
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 //Access the last object from locations to get perfect current location
 if let location = locations.last {
 let span = MKCoordinateSpanMake(0.00775, 0.00775)
 let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
 let region = MKCoordinateRegionMake(myLocation, span)
 map.setRegion(region, animated: true)
 }
 self.map.showsUserLocation = true
 manager.stopUpdatingLocation()
 }
 
 
 @IBAction func refLocation(_ sender: Any) {
 locationManager.startUpdatingLocation()
 }
 }
 

