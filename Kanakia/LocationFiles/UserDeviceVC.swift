//
//  UserDeviceVC.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 9/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import CoreLocation


class UserDeviceVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
   

    @IBOutlet weak var tblUserDevice: UITableView!
    
    var deviceArr = [Any]()
    var UserName : String = ""
    var ref:DatabaseReference! = nil
    var handle : DatabaseHandle!
    var src = CLLocationCoordinate2D.self
    var dst = CLLocationCoordinate2D.self
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

          tblUserDevice.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        self.tblUserDevice.delegate = self
        self.tblUserDevice.dataSource = self
        ref = Database.database().reference()
        self.loadDataFromFirebase()
    }

    func setDevice(Arr : String)
    {
        self.UserName = Arr
    }
    

    func loadDataFromFirebase()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let devicenm = Database.database().reference().child(self.UserName)
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
   
    // MARK : TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return self.deviceArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblUserDevice.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        cell.lblName.text = self.deviceArr[indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.getAutoId(Userstr: self.UserName, DeviceStr: self.deviceArr[indexPath.row] as! String)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
