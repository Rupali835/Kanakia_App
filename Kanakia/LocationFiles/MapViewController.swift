//
//  MapViewController.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 9/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase


class MapViewController: UIViewController
{

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var deviceNm : String!
    var userNm : String!
    var ref:DatabaseReference! = nil
    var handle : DatabaseHandle!
    var latitude : Double!
    var longitude : Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
          self.readFromFirebase()
       
    }

    
    func getAutoId(Userstr : String, DeviceStr : String)
    {
        self.userNm = Userstr
        self.deviceNm = DeviceStr
    }
    
    func readFromFirebase()
    {
        
        let DataRef = Database.database().reference().child(self.userNm).child(self.deviceNm)
        
        let DataObserve = DataRef.observe(.value) { (snapshot) in
            print(snapshot)
            
            let path =  GMSMutablePath()
            
            for snap in snapshot.children.allObjects
            {
                if let snap = snap as? DataSnapshot
                {
                    if let latSome = snap.childSnapshot(forPath: "latitude").value as? Double
                    {
                        self.latitude = latSome as? Double
                         print(self.latitude)
                    }
                    
                    if let longSome = snap.childSnapshot(forPath: "longitude").value as? Double
                    {
                        self.longitude = longSome as? Double
                        print(self.longitude)
                        
                    }
           
                    
                    if (self.latitude == nil) && (self.longitude == nil)
                    {
                        return
                    }else
                    {
                        path.addLatitude(self.latitude, longitude: self.longitude)
                    }
                    
                    //                   path.addLatitude(19.192798, longitude: 72.986534)
                    //                   path.addLatitude(19.197084, longitude: 72.986126)
                    //                   path.addLatitude(19.194997, longitude: 72.988433)
                    //                   path.addLatitude(19.195433, longitude: 72.990525)
                    //                   path.addLatitude(19.193265, longitude: 72.988776)
                    
                    let polyLine = GMSPolyline(path: path)
                    polyLine.strokeWidth = 6.0
                    polyLine.geodesic = true
                    polyLine.map = self.mapView
                    polyLine.strokeColor = .red
                    
                }
            }
            
            let hydeParkLocation = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            let camera = GMSCameraPosition.camera(withTarget: hydeParkLocation, zoom: 20)
            self.mapView?.animate(to: camera)
            
        }
        
    }
    func createLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }

    
    
  
}
