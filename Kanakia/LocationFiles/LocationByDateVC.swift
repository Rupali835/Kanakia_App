//
//  LocationByDateVC.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 9/18/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class LocationByDateVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  
    @IBOutlet weak var btnSelectDevice: UIButton!
    @IBOutlet weak var btnSelectUser: UIButton!
    
    @IBOutlet weak var tblDevice: UITableView!
    @IBOutlet weak var tblUser: UITableView!
    @IBOutlet var viewForDevice: UIView!
    @IBOutlet var viewForUser: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewDate: UIView!
    
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var popUp : KLCPopup!
    var DateStr : String?
    var userList = [AnyObject]()
    var deviceList = [AnyObject]()
    var locationList = [AnyObject]()
     private var toast: JYToast!
    var TdId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp = KLCPopup()
       createDatePicker()
        
        tblUser.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        tblDevice.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        tblUser.delegate  = self
        tblUser.dataSource = self
        tblDevice.delegate = self
        tblDevice.dataSource = self
        tblUser.separatorStyle = .none
        tblDevice.separatorStyle = .none
        fetchUserList()
        toast = JYToast()
    }
    
    func createDatePicker()
    {
        _ = Date()
        datepicker.maximumDate = Date()
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtDate.inputAccessoryView = toolBar
        txtDate.inputView = datepicker
    }
    
    @objc func donePresses()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        txtDate.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
        self.view.endEditing(true)
    }

    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }

    // MARK : BUTTON ACTION
    
    @IBAction func btnPicker_OnClick(_ sender: Any)
    {
        createDatePicker()
    }
    
    @IBAction func btnSelectUser_OnClick(_ sender: Any)
    {
        viewForDevice.isHidden = true
        viewForUser.isHidden = false
        popUp.contentView = viewForUser
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblUser.reloadData()
    }
    
    @IBAction func btnSelectDevice_OnClick(_ sender: Any)
    {
        viewForUser.isHidden = true
        viewForDevice.isHidden = false
        popUp.contentView = viewForDevice
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblDevice.reloadData()
    }
   
    
// MARK : TABLEVIEW METHOSD
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == tblUser
        {
            return userList.count
        }else if tableView == tblDevice
        {
            return deviceList.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == tblUser
        {
           let cell = tblUser.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            let lcdict = userList[indexPath.row]
            let userNm = lcdict["user_name"] as! String
            cell.lblName.text = userNm
            self.designCell(cView: cell.backView)
            return cell
        }else if tableView == tblDevice
        {
            let cell = tblDevice.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            
            let lcdict = deviceList[indexPath.row]
            let devicenm = lcdict["td_name"] as! String
            cell.lblName.text = devicenm
            self.designCell(cView: cell.backView)
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == tblUser
        {
            let lcdict = userList[indexPath.row]
            let usernm = lcdict["user_name"] as! String
            let userid = lcdict["user_id"] as! String
            btnSelectUser.setTitle(usernm as? String, for: .normal)
            popUp.dismiss(true)
            fetchDeviceList(userid: userid)
            
            
        }else if tableView == tblDevice
        {
            let lcdict = deviceList[indexPath.row]
            let devicenm = lcdict["td_name"] as! String
            self.TdId = lcdict["td_id"] as! String
            btnSelectDevice.setTitle(devicenm as? String, for: .normal)
            popUp.dismiss(true)
           
        }
    }
    
    func fetchUserList()
    {
        let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/getDeviceUser"
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (resp) in
            let json = resp.result.value as! NSDictionary
            let userlist = json["user_list"] as AnyObject
            self.userList = userlist as! [AnyObject]
            
        }
        
    }
    
    func fetchDeviceList(userid : String)
    {
        let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/getDevice"
        let param : [String : Any] = ["user_id" : userid]
        Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
       
            let json = resp.result.value as! NSDictionary
            let devicelist = json["device_list"] as AnyObject
            self.deviceList = devicelist as! [AnyObject]
            
        }
    }
    
    func fetchLocation(tdid : String)
    {
         let path =  GMSMutablePath()
        
        if txtDate.text == ""
        {
            self.toast.isShow("Please enter date")
        }else{
            
            let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/getLocation"
            let param : [String : Any] = ["td_id" : tdid,
                                          "date" : self.DateStr!]
            Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
                print(resp)
                
                let json = resp.result.value as! NSDictionary
                
                let msg = json["msg"] as! String
                
                if msg == "success"
                {
                    self.mapView.clear()
                    self.locationList = json["location"] as! [AnyObject]
                    
                    for val in self.locationList
                    {
                        let lat = Double(val["l_lat"] as! String)
                        let long = Double(val["l_long"] as! String)
                        
                        path.addLatitude(lat!, longitude: long!)
                        
                        let polyLine = GMSPolyline(path: path)
                        polyLine.strokeWidth = 6.0
                        polyLine.geodesic = true
                        polyLine.map = self.mapView
                        polyLine.strokeColor = .red
                        
                        let hydeParkLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                        let camera = GMSCameraPosition.camera(withTarget: hydeParkLocation, zoom: 20)
                        self.mapView?.animate(to: camera)
                    }
                    
                  }else if msg == "fail"
                {
                    self.toast.isShow("location not found")
                }
            }
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

    @IBAction func btnGetLocation_OnClick(_ sender: Any)
    {
        if TdId != nil
        {
            fetchLocation(tdid: self.TdId)
        }else{
            self.toast.isShow("something went wrong")
        }
        
    }
    
}
