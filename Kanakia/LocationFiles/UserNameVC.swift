//
//  UserNameVC.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 9/11/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserNameVC: UIViewController, UITableViewDelegate,
    UITableViewDataSource
{
   
    @IBOutlet weak var tblUserName: UITableView!
    
    var backgroundTask: UIBackgroundTaskIdentifier!

    
    var ref:DatabaseReference! = nil
    var handle : DatabaseHandle!
    var keyArray = [String]()
  
    var UserName : String!
    var UserDevice : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tblUserName.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        tblUserName.delegate = self
        tblUserName.dataSource = self
        
        ref = Database.database().reference()
        self.readFromDatabase()
        
        
    }

    
    // MARK : EXTRA FUNCTIONS
    
    func readFromDatabase()
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
                
                self?.tblUserName.reloadData()
                self?.ref.removeObserver(withHandle: handle)
            }
        }
    }
    
    
    
    // MARK : TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblUserName.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let lcdict = self.keyArray[indexPath.row]
        cell.lblName.text = lcdict
        return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let lcdata = self.keyArray[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDeviceVC") as! UserDeviceVC
        vc.setDevice(Arr: lcdata)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}
