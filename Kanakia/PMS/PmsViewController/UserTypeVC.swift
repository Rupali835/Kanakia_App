//
//  UserTypeVC.swift
//  Kanakia SOP
//
//  Created by user on 02/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class UserTypeVC: UIViewController {

    
    @IBOutlet weak var SBtn: UIButton!
    @IBOutlet weak var FstBtn: UIButton!
    @IBOutlet weak var TrdVc: UIView!
    @IBOutlet weak var Tbtn: UIButton!
    @IBOutlet weak var SndVc: UIView!
    @IBOutlet weak var FirstVc: UIView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnPendingApproval: UIButton!
    @IBOutlet weak var BtnMyTeam: UIButton!
    @IBOutlet weak var BtnMyKra: UIButton!
    
    var Up_id: String = ""
    var up_Id : String!
    var upType : String!
    var Check = Bool(false)
    var strUserName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

   //      self.navigationController?.navigationBar.barTintColor = UIColor(red:0.61, green:0.16, blue:0.69, alpha:1.0)
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
       strUserName = userDict["user_emp_id"] as! String
    
        self.FstBtn.layer.borderColor = UIColor.purple.cgColor
        self.SBtn.layer.borderColor = UIColor.purple.cgColor
        self.Tbtn.layer.borderColor = UIColor.purple.cgColor
        self.dropShadow(cView: FirstVc)
        self.dropShadow(cView: SndVc)
        self.dropShadow(cView: TrdVc)
        
        DispatchQueue.main.async {
            self.getUserType()
            self.getPendingCount()

        }
}

    func dropShadow(cView : UIView) {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.5
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    func setupData(cId: String)
    {
        self.Up_id = cId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OnMyKra_Click(_ sender: Any)
    {
     
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "Kra_FeedbackVc") as! Kra_FeedbackVc
        Fvc.setupData(cId: self.up_Id)
        Fvc.Check = Check
        navigationController?.pushViewController(Fvc, animated: true)
        print("Kra Feedback")
    }
    
    @IBAction func OnMyTeam_Click(_ sender: Any)
    {
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "ListOfMyTeamVC") as! ListOfMyTeamVC
        navigationController?.pushViewController(Fvc, animated: true)
    }
    
    
    @IBAction func OnPendingApproval_Click(_ sender: Any)
    {
        let Svc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "PendingApprovalVc") as! PendingApprovalVc
        navigationController?.pushViewController(Svc, animated: true)
    }
    
    
  
    
    func getUserType()
    {
        let userUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getUserType"
        let userParam =  ["user_emp_id" : self.strUserName,
                          "type" : "ios"]
        
        Alamofire.request(userUrl, method: .post, parameters: userParam).responseJSON { (resp) in
            print(resp)
            let data = resp.result.value as! [String : Any]
            let Msg = data["msg"] as! [String: Any]
            
            UserDefaults.standard.set(Msg, forKey: "msg")
            self.up_Id = Msg["up_id"] as! String
            self.upType = Msg["up_type"] as! String
            print("Up_id", self.up_Id)
            print("UP_type", self.upType)
      
    }
}
    
    func getPendingCount()
    {
        let countUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getPendingApprovalsCount"
        let param = ["up_id" : self.Up_id]
        print("Parameter", param)
        Alamofire.request(countUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            let number = resp.result.value as! Int
            print("Count", number)
            self.lblCount.text = "(" + "\(number)" + ")"
            
        }
    }
    
    
}

