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
import Alamofire

class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate, FirebaseMapDelegate
{
   
  
   
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tblUserDevice: UITableView!
    @IBOutlet weak var tblUserName: UITableView!
    @IBOutlet var viewUserDevice: UIView!
    @IBOutlet var viewUserName: UIView!
    @IBOutlet weak var btnSelectDevice: UIButton!
    @IBOutlet weak var btnSelectUser: UIButton!
    
    var locationManager = CLLocationManager()
    var marker = GMSMarker()
    var deviceNm : String!
    var ref:DatabaseReference! = nil
    var handle : DatabaseHandle!
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var popUp : KLCPopup!
    var keyArray = [String]()
    var UserNm : String!
    var deviceArr = [Any]()
    private var toast: JYToast!
    var UserArr = [AnyObject]()
    var usernmArr = [String]()
    var userId : String = ""
    var strUserId : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        popUp = KLCPopup()
       
        toast = JYToast()
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
       self.strUserId = userDict["user_id"] as! String
        
           tblUserName.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
          tblUserDevice.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
    }
    
    
    func getAutoId(Userstr : String, DeviceStr : String)
    {
        self.UserNm = Userstr
        self.deviceNm = DeviceStr
    }
    
    
    func readFromDatabaseUserName(sender : UIButton, tag : Int)
    {
        ref = Database.database().reference()
        handle = ref.observe(.value) { [weak self] (snapshot) in
            guard let handle = self?.handle else { return }
            
            print(snapshot)
            if snapshot.exists()
            {
                self?.keyArray.removeAll(keepingCapacity: false)
                for snap in snapshot.children.allObjects
                {
                    if let snap = snap as? DataSnapshot
                    {
                        let key = snap.key
                        self?.keyArray.append(key)
                       
                        }
                }
               self?.takeUserNm(sender: sender, tag: 1)
               self?.tblUserName.reloadData()
               self?.ref.removeObserver(withHandle: handle)
               
            }else
            {
                self?.toast.isShow("No data found")
            }
        }
    }
    
    func takeUserNm(sender : UIButton, tag : Int)
    {
        let apiUrl = "http://kanishkagroups.com/sop/android/getDetailsMms.php"
        let param : [String: Any] = ["logged_in_user_id" : self.strUserId,
                                     "type" : "ios"]
        
        Alamofire.request(apiUrl, method: .post, parameters: param).responseJSON { (resp) in
            let json = resp.result.value as! NSDictionary
            let userA = json["user"] as AnyObject
            self.UserArr = userA as! [AnyObject]
            
            self.usernmArr.removeAll(keepingCapacity: false)

            for UserId in self.keyArray
            {
                
            for lcDict in self.UserArr
            {
               let User_Id = lcDict["user_id"] as! String
                
                if UserId == User_Id
                {
                  print("\(lcDict["user_name"])")
                    self.usernmArr.append(lcDict["user_name"] as! String)
                    self.userId = User_Id
                    
                }
                
            }
        }
            self.OpenPopUp(sender: sender, tag: 1)
    }
  }
    
    func readFromFirebaseForMap(usernm : String, devicenm : String)
    {
        mapView.clear()
        let DataRef = Database.database().reference().child(usernm).child(devicenm)
        
        let DataObserve = DataRef.observe(.value) { (snapshot) in
            print(snapshot)
            
            if snapshot.exists()
            {
                self.mapView.clear()
                let path =  GMSMutablePath()
                
                for snap in snapshot.children.allObjects
                {
                   // mapView.clear()
                    
                    if let snap = snap as? DataSnapshot
                    {
                        if let latSome = snap.childSnapshot(forPath: "latitude").value as? Double
                        {
                            self.latitude = latSome
                            print(self.latitude)
                        }
                        
                        if let longSome = snap.childSnapshot(forPath: "longitude").value as? Double
                        {
                            self.longitude = longSome
                            print(self.longitude)
                        }
                        
                        
                        if (self.latitude == nil) && (self.longitude == nil)
                        {
                            return
                        }else
                        {
                            path.addLatitude(self.latitude, longitude: self.longitude)
                        }
                        
                        let polyLine = GMSPolyline(path: path)
                        polyLine.strokeWidth = 4.0
                        polyLine.geodesic = true
                        polyLine.map = self.mapView
                        polyLine.strokeColor = .red
                        
                    }
                }
                
                let position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                let marker = GMSMarker(position: position)
                marker.icon = GMSMarker.markerImage(with: .blue)
                marker.map = self.mapView
                
                let hydeParkLocation = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
                let camera = GMSCameraPosition.camera(withTarget: hydeParkLocation, zoom: 20)
                self.mapView?.animate(to: camera)
                
            }else
            {
              self.toast.isShow("location not found")
            }
          
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

    @IBAction func btnSelectUser_OnClick(_ sender: UIButton)
    {
        readFromDatabaseUserName(sender: sender, tag : 1)

       
    }
    
    
    @IBAction func btnSelectDevice_OnClick(_ sender: UIButton)
    {
        OpenPopUp(sender: sender, tag: 2)
    }
    
 
    func OpenPopUp(sender : UIButton, tag : Int)
    {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirebasePopUpVC") as! FirebasePopUpVC
        popController.delegate = self
        popController.Tag = tag
        
        popController.getData(lcUserId: userId, lcUserListArr: self.usernmArr)
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender  // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        popController.preferredContentSize = CGSize(width: 300, height: 0)
        self.present(popController, animated: true, completion: nil)
        
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    func sendData(lcUserDict: [String])
    {
        for val in lcUserDict
        {
           btnSelectUser.setTitle(val, for: .normal)
        }
    }
    
    func sendDataForLocation(userId: String, deviceNm: String)
    {
        btnSelectDevice.setTitle(deviceNm, for: .normal)
        readFromFirebaseForMap(usernm: userId, devicenm: deviceNm)
    }
    
    
}
