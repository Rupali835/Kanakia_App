//
//  PendingApprovalVc.swift
//  Kanakia SOP
//
//  Created by user on 09/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class PendingApprovalVc: UIViewController, UITableViewDelegate,UITableViewDataSource,HighlightLowLightDelegate
{

    @IBOutlet weak var tblPending: UITableView!
    
    private var toast: JYToast!
    var Up_id : String! = ""
    var Msg = [AnyObject]()
    var cRemarkVc : RemarkActionVc!
    var fkId : String!
     override func viewDidLoad() {
        super.viewDidLoad()

        initUi()
        tblPending.delegate = self
        tblPending.dataSource = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.tblPending.separatorStyle = .none
        self.tblPending.estimatedRowHeight = 80
        self.tblPending.rowHeight = UITableViewAutomaticDimension
        let dict  = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        self.Up_id = dict["up_id"] as! String
    
         tblPending.register(UINib(nibName: "PendingAchiveCell", bundle: nil), forCellReuseIdentifier: "PendingAchiveCell")
        
        tblPending.register(UINib(nibName: "PendingHighLowCell", bundle: nil), forCellReuseIdentifier: "PendingHighLowCell")
        
         tblPending.register(UINib(nibName: "PendingKpiCell", bundle: nil), forCellReuseIdentifier: "PendingKpiCell")
         PendingAppCount()
    
        
    }

    func PendingAppCount()
    {
        let countUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getPendingApprovalsCount"
        let countParam : [String: Any] = ["up_id" : self.Up_id!]
        print("up_id", countParam)
        Alamofire.request(countUrl, method: .post, parameters: countParam).responseJSON { (dataCount) in
            print(dataCount)
            
        }
        
    }
    
  
    override func viewWillAppear(_ animated: Bool)
    {
         GetPendingData()
    }
    private func initUi() {
        toast = JYToast()
    }
    
    override func awakeFromNib()
    {
        self.cRemarkVc = self.storyboard?.instantiateViewController(withIdentifier: "RemarkActionVc") as! RemarkActionVc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func GetPendingData()
    {
        let url = "http://kanishkagroups.com/sop/pms/index.php/API/getPendingApprovals"
        let Param : [String: Any] = ["up_id" : self.Up_id!,
                                     "type" : "ios"] 
        print(Param)
        Alamofire.request(url, method: .post, parameters: Param).responseJSON { (dataAchive) in
           print(dataAchive)
            self.Msg = dataAchive.result.value as! [AnyObject]
            
            if self.Msg.isEmpty == true
            {
                self.toast.isShow("No any Pending Approvals")
            }else{
               
                self.tblPending.reloadData()
            }
          
        
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var TrainType : String = ""
        let lcDict = Msg[indexPath.row]
        let type = lcDict["app_type"] as! String
        if type == "1" || type == "2" || type == "5" || type == "7"
        {
        let cell = tblPending.dequeueReusableCell(withIdentifier: "PendingAchiveCell", for: indexPath) as! PendingAchiveCell
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        cell.lblChangeNm.text = "Other Achievements"
        cell.lblEmpName.text = (lcDict["app_for_user_name"] as! String)
        cell.lblMainInfo.text = (lcDict["app_name"] as! String)
        cell.lblDateTime.text = (lcDict["timestamp"] as! String)
        cell.TrainType.text = ""
        
        
            if type == "2"
            {
                cell.lblChangeNm.text = "Training Needs"
                TrainType = (lcDict["tpt_type"] as! String)
                if TrainType == "1"
                {
                    cell.TrainType.text = "(Technical)"
                }
                if TrainType == "2"
                {   
                    cell.TrainType.text = "(behaviour)"
                }
                
            }
            if type == "5"
            {
                cell.lblChangeNm.text = "Feedback"
                cell.TrainType.text = ""
            }
            
            if type == "7"
            {
                cell.lblChangeNm.text = "KRA Acceptance"
                cell.TrainType.text = ""
                cell.btnReject.isHidden = true
            }
            
            cell.btnAccept.tag = indexPath.row
            cell.btnReject.tag = indexPath.row
            cell.btnAccept.addTarget(self, action: #selector(Accept_Click(sender:)), for: .touchUpInside)
            cell.btnReject.addTarget(self, action: #selector(Reject_Click(sender:)), for: .touchUpInside)
       //     cell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)
            
            return cell
            
        }else if type == "3" || type == "6"
        {
            let cell = tblPending.dequeueReusableCell(withIdentifier: "PendingHighLowCell", for: indexPath) as! PendingHighLowCell
            
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            self.designCell(cView: cell.backView)
            cell.KraNm.text = (lcDict["k_name"] as! String)
            cell.KpiNm.text = (lcDict["kpi_name"] as! String)
            cell.lblLightNm.text = (lcDict["app_name"] as! String)
            cell.lblEmpNm.text = (lcDict["app_for_user_name"] as! String)
            cell.lblDate.text = (lcDict["timestamp"] as! String)
            if type == "6"
            {
                cell.lblChangeNm.text = "LowLights"
                cell.NameLight.text = "LowLights:"
                cell.NameLight.font = UIFont.boldSystemFont(ofSize: 15.0)
            }
            
            cell.btnAcceptLight.tag = indexPath.row
            cell.btnRejectLgt.tag = indexPath.row
            cell.btnAcceptLight.addTarget(self, action: #selector(AcceptLight_Click(sender:)), for: .touchUpInside)
            cell.btnRejectLgt.addTarget(self, action: #selector(RejectLight_Click(sender:)), for: .touchUpInside)
 
            return cell
        }
        else{
            let cell = tblPending.dequeueReusableCell(withIdentifier: "PendingKpiCell", for: indexPath) as! PendingKpiCell
            
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            self.designCell(cView: cell.backView)
            cell.lblEmpNm.text = (lcDict["app_for_user_name"] as! String)
            cell.lblKpiNm.text = (lcDict["kpi_name"] as! String)
            cell.lblKraNm.text = (lcDict["k_name"] as! String)
            cell.lblDate.text = (lcDict["timestamp"] as! String)
            cell.lblAchievedData.text = (lcDict["app_name"] as! String)
     
            cell.btnAccept.tag = indexPath.row
            cell.btnReject.tag = indexPath.row
           cell.btnAccept.addTarget(self, action: #selector(AcceptKpi_Click(sender:)), for: .touchUpInside)
            cell.btnReject.addTarget(self, action: #selector(RejectKpi_Click(sender:)), for: .touchUpInside)
   
            
            return cell
        }
    }
   
 
    @objc func AcceptKpi_Click(sender: UIButton)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to accept this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
            let index = sender.tag
            let lcDict = self.Msg[index]
            let type = lcDict["app_type"] as! String
            if type == "4"
            {
                self.GetApprovedRejectKpi(nIndex: index, nStatus: 1)
            }
            self.toast.isShow("Successfully Accepcted")
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        GetPendingData()
    }
   
    @objc func RejectKpi_Click(sender: UIButton)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to reject this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let index = sender.tag
            let lcDict = self.Msg[index]
            let type = lcDict["app_type"] as! String
            print(type)
            if type == "4"
            {
                self.GetApprovedRejectKpi(nIndex: index, nStatus: 2)
            }
             self.toast.isShow("Successfully Rejected")
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        GetPendingData()
        
      
    }
    
    @objc func GetApprovedRejectKpi(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
     
        let KpiParam : [String: Any] =
            [ "pkdi_id" : lcDict["id"] as! String,
              "pkdi_status" : nStatus,
              "approved_by" : self.Up_id,
        ]
        
        print("AcceptParam", KpiParam)
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectAchievedKPI"
        
        Alamofire.request(StringURl, method: .post, parameters: KpiParam).responseJSON { (data) in
            print("Data", data)
            self.GetPendingData()
            self.tblPending.reloadData()
        }
    }
    

    func GetApprovedRejectAchievement(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
        
        let Acceptparam : [String: Any] =
            [ "tpa_status" : nStatus,
              "tpa_id" : lcDict["id"] as! String,
              "tpa_approved_by" : self.Up_id as AnyObject
        ]
        print(Acceptparam)
        let AchivURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectAchievement"
        
        Alamofire.request(AchivURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.GetPendingData()
            
            
        }
    }
    
    func GetApprovedRejectTraining(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
        
        let Acceptparam : [String: Any] =
            [ "tpt_status" : nStatus,
              "tpt_id" : lcDict["id"] as! String,
              "tpt_approved_by" : self.Up_id as AnyObject
        ]
        
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectTraining"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.GetPendingData()
           
            
        }
    }
    
    func GetApprovedRejectFeedback(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
        
        let Acceptparam : [String: Any] =
            [ "tpf_status" : nStatus,
              "tpf_id" : lcDict["id"] as! String,
              "tpf_approved_by" : self.Up_id as AnyObject
        ]
        
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectFeedback"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.GetPendingData()
            
            
        }
    }
    
    func AcceptManagerKRA(nIndex: Int)
    {
     
         let lcDict = self.Msg[nIndex]
        let acceptKra = "http://kanishkagroups.com/sop/pms/index.php/API/acceptKRAManager"
        
        let Param : [String: Any] =
            [        "up_id" :  lcDict["id"] as! String,
                     "manager_up_id" : self.Up_id
        ]
        
        print(Param)
        Alamofire.request(acceptKra, method: .post, parameters: Param).responseJSON { (addResp) in
            
            print(addResp)
         
            self.GetPendingData()
        }
    }
    
    @objc func Accept_Click(sender:UIButton)
    {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to accept this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let index = sender.tag
            let lcDict = self.Msg[index]
            let type = lcDict["app_type"] as! String
            if type == "1"
            {
                print("index=", index)
                self.GetApprovedRejectAchievement(nIndex: index, nStatus: 1)
            }else if type == "2"
            {
                self.GetApprovedRejectTraining(nIndex: index, nStatus: 1)
            }
            else if type == "7"
            {
                self.AcceptManagerKRA(nIndex: index)
            }
            else
            {
                self.GetApprovedRejectFeedback(nIndex: index, nStatus: 1)
            }
            self.toast.isShow("Successfully Accepted")
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        GetPendingData()
        
    }
    
    @objc func Reject_Click(sender:UIButton)
    {
      
        let alert = UIAlertController(title: "Alert", message: "Are you sure to reject this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let index = sender.tag
            print("index=", index)
            let lcDict = self.Msg[index]
            let type = lcDict["app_type"] as! String
            if type == "1"
            {
                print("index=", index)
                self.GetApprovedRejectAchievement(nIndex: index, nStatus: 2)
            }else if type == "2"
            {
                self.GetApprovedRejectTraining(nIndex: index, nStatus: 2)
            }
            else
            {
                self.GetApprovedRejectFeedback(nIndex: index, nStatus: 2)
            }
            self.toast.isShow("Successfully Rejected")
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        GetPendingData()
        
    }
    
    @objc func RejectLight_Click(sender: UIButton)
    {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to reject this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            
            let index = sender.tag
            let lcDict = self.Msg[index]
            let type = lcDict["app_type"] as! String
            self.fkId = lcDict["id"] as! String
            self.cRemarkVc.view.frame = self.view.bounds
            
            if let cSelectedStr = self.fkId
            {
                self.cRemarkVc.setVal(nStatus: 2, Fkid: cSelectedStr)
            }
             self.cRemarkVc.delegate = self
            self.view.addSubview(self.cRemarkVc.view)
            self.cRemarkVc.view.clipsToBounds = true
            self.tblPending.reloadData()
            self.toast.isShow("Successfully Rejected")

            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
      GetPendingData()

    }
    
    @objc func AcceptLight_Click(sender: UIButton)
    {
           let alert = UIAlertController(title: "Alert", message: "Are you sure you want to accept this highlights?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                let index = sender.tag
                let lcDict = self.Msg[index]
                
                //self.fkId = lcDict["id"] as! String
                
                self.cRemarkVc.view.frame = self.view.bounds
                
                if let cSelectedStr = lcDict["id"] as? String
                {
                    self.cRemarkVc.setVal(nStatus: 1, Fkid: cSelectedStr)
                }
                self.cRemarkVc.delegate = self
                self.view.addSubview(self.cRemarkVc.view)
                self.cRemarkVc.view.clipsToBounds = true
                
                let type = lcDict["app_type"] as! String
            }
            
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        
       

    }
    
    func showAlert(title: String, Msg: String)
    {
    let alert = UIAlertController(title: title, message: Msg, preferredStyle: UIAlertControllerStyle.alert)

    let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
    UIAlertAction in


    }

    let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
    UIAlertAction in
    NSLog("Cancel Pressed")
    }
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)

    }
    
    func didSelected()
    {
        self.GetPendingData()
    }
 
}
