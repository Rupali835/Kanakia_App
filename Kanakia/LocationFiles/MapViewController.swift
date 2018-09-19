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

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
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
    var latitude : Double!
    var longitude : Double!
    var popUp : KLCPopup!
    var keyArray = [String]()
    var UserNm : String!
    var deviceArr = [Any]()
    private var toast: JYToast!
    var UserArr = [AnyObject]()
    var usernmArr = [String]()
    var userId : String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
         popUp = KLCPopup()
       
        toast = JYToast()
           tblUserName.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
          tblUserDevice.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        mapView.settings.myLocationButton = true
        
        tblUserName.delegate = self
        tblUserName.dataSource = self
        tblUserDevice.delegate = self
        tblUserDevice.dataSource = self
        tblUserName.separatorStyle = .none
        tblUserDevice.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
           takeUserNm()
           self.readFromDatabaseUserName()
    }

    func getAutoId(Userstr : String, DeviceStr : String)
    {
        self.UserNm = Userstr
        self.deviceNm = DeviceStr
    }
    
    
    func readFromDatabaseUserName()
    {
        ref = Database.database().reference()
        handle = ref.observe(.value) { [weak self] (snapshot) in
            guard let handle = self?.handle else { return }
            
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
                
              
             //   self?.ref.removeObserver(withHandle: handle)
                  self?.tblUserName.reloadData()
            }
        }
    }
    
    func takeUserNm()
    {
        let apiUrl = "http://kanishkagroups.com/sop/android/getDetailsMms.php"
        let param : [String: Any] = ["logged_in_user_id" : "",
                                     "type" : ""]
        
        Alamofire.request(apiUrl, method: .post, parameters: param).responseJSON { (resp) in
            let json = resp.result.value as! NSDictionary
            let userA = json["user"] as AnyObject
            self.UserArr = userA as! [AnyObject]
            
            for UserId in self.keyArray{
              
                print("\(UserId)")
            for lcDict in self.UserArr
            {
               let User_Id = lcDict["user_id"] as! String
                
                if UserId == User_Id
                {
                  print("\(lcDict["user_name"])")
                    self.usernmArr.append(lcDict["user_name"] as! String)
                }
                
            }
        }
    }
}
    
    func loadDataFromFirebaseForDevice(usernm : String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if UserNm != ""
        {
            let devicenm = Database.database().reference().child(usernm)
            handle = devicenm.observe(.value) { [weak self] (snapshot) in
                guard let handle = self?.handle else { return }
                
                if snapshot.exists()
                {
                    self?.deviceArr.removeAll(keepingCapacity: false)
                    for snap in snapshot.children.allObjects
                    {
                        if let snap = snap as? DataSnapshot
                        {
                            let key = snap.key
                            self?.deviceArr.append(key)
                            let lat = snap.value
                            
                        }
                    }
                    
                    self?.tblUserDevice.reloadData()
                    self?.ref.removeObserver(withHandle: handle)
                }
            }
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

    @IBAction func btnSelectUser_OnClick(_ sender: Any)
    {
        viewUserDevice.isHidden = true
        viewUserName.isHidden = false
        popUp.contentView = viewUserName
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        
        tblUserName.reloadData()
        
       
    }
    
    
    @IBAction func btnSelectDevice_OnClick(_ sender: Any)
    {
        viewUserName.isHidden = true
        viewUserDevice.isHidden = false
        popUp.contentView = viewUserDevice
        popUp.maskType = .dimmed
       
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
            popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblUserDevice.reloadData()
      
    }
    
    // MARK : TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblUserName
        {
            return usernmArr.count
        }else{
            return deviceArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(tableView)
        if tableView == tblUserName
        {
            
            let celll = tblUserName.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            self.UserNm = self.usernmArr[indexPath.row]
            self.designCell(cView: celll.backView)
            celll.lblName.text = self.UserNm
            
            return celll
            
        }else if tableView == tblUserDevice
        {
            let cell = tblUserDevice.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            self.deviceNm = self.deviceArr[indexPath.row] as! String
            self.designCell(cView: cell.backView)
            cell.lblName.text = self.deviceNm
      
            return cell
        }
        else{
             return UITableViewCell()
        }
       
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblUserName
        {
            self.UserNm = usernmArr[indexPath.row]
            userId = self.keyArray[indexPath.row]
            btnSelectUser.setTitle(self.UserNm, for: .normal)
            loadDataFromFirebaseForDevice(usernm: userId)
            popUp.dismiss(true)

           
        }else if tableView == tblUserDevice
        {
            //let usernm = self.keyArray[indexPath.row]
            self.deviceNm = deviceArr[indexPath.row] as! String
            btnSelectDevice.setTitle(self.deviceNm, for: .normal)
            popUp.dismiss(true)

            self.readFromFirebaseForMap(usernm: userId, devicenm: self.deviceNm)
        }
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
        cView.backgroundColor = UIColor.white
    }
    
    
    
    
}
