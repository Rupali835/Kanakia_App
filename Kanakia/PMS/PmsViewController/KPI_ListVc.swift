//
//  KPI_ListVc.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class KPI_ListVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var lblKraNm: UILabel!
    @IBOutlet weak var tblKpi_List: UITableView!
    var Up_id : String = ""
    var Msg = [AnyObject]()
    var Select_Kid : String = ""
    var K_id : String = ""
    var Kpi_Name : String = ""
    var Kpi_id : String!
    var vcLight : HighLowlightsVc!
    var cell : With_TargetKpiCell!
    var LoginUp_id : String = ""
     var dict : NSDictionary!
     var valid = Bool(true)
     private var toast: JYToast!
    var cEmpflg : String!
    var cMngrflg : String!
    var txtValue : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.leftBarButtonItem?.title = ""

        self.lblKraNm.text = self.Kpi_Name
        self.tblKpi_List.separatorStyle = .none
        self.tblKpi_List.estimatedRowHeight = 80
        self.tblKpi_List.rowHeight = UITableViewAutomaticDimension
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        
        self.tblKpi_List.delegate = self
        self.tblKpi_List.dataSource = self
         tblKpi_List.register(UINib(nibName: "Without_TargetKpiCell", bundle: nil), forCellReuseIdentifier: "Without_TargetKpiCell")
        
        tblKpi_List.register(UINib(nibName: "With_TargetKpiCell", bundle: nil), forCellReuseIdentifier: "With_TargetKpiCell")
        
//        let dict  = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
//        self.Up_id = dict["up_id"] as! String
        initUi()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

      
    }

    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private func initUi() {
        toast = JYToast()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setKid(Kk_id : String, Kname: String)
    {
        self.K_id = Kk_id
        self.Kpi_Name = Kname
        
        if Kname.contains("XCXC")
        {
            let word = Kname
            if let index = word.range(of: "XCXC")?.lowerBound {
                let substring = word[..<index]
                self.K_id = String(substring)
                
            }
            
            if let range = word.range(of: "XCXC") {
               let name = word[range.upperBound...]
                self.Kpi_Name = String(name)
              
            }
            
    
        }
       
        getKpi()
    }
    
    func setId(Kk_id: String, Up_id: String, KName: String, lcempFlag: String, lcMngrFlag: String)
    {
        self.K_id = Kk_id
        self.Up_id = Up_id
        self.Kpi_Name = KName
        self.cEmpflg = lcempFlag
        self.cMngrflg = lcMngrFlag
        
       getKpi()
    }
    
    func getRandomColor() -> UIColor
    {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func getKpi()
    {
        let KpiURL = "http://kanishkagroups.com/sop/pms/index.php/API/getKPI"
        let KpiParam = ["k_id" : self.K_id,
                        "type" : "ios" ]
        Alamofire.request(KpiURL, method: .post, parameters: KpiParam).responseJSON { (dataAchive) in
            let data = dataAchive.result.value as! [String: AnyObject]
            print(data)
            self.Msg = data["msg"] as! [AnyObject]
            print("dict=",self.Msg)
            if self.Msg.count == 0
            {
               self.toast.isShow("No Any KPI found")
            }
            self.tblKpi_List.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let indexNumber = indexPath.row + 1
        let lcDict = self.Msg[indexPath.row]
        let Kpi_type = lcDict["kpi_type"] as! String
      
        if Kpi_type == "1"
        {
            let cell = tblKpi_List.dequeueReusableCell(withIdentifier: "Without_TargetKpiCell", for: indexPath) as! Without_TargetKpiCell
            
            let lcDict = self.Msg[indexPath.row]
            let lcUserName = lcDict["kpi_name"] as! String
            let firstLetter = lcUserName.first!
            
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            self.designCell(cView: cell.back_View)
            
            cell.lblKpiName.text = (lcDict["kpi_name"] as! String)
            cell.btnViewOrAdd.tag = indexPath.row
            cell.lblFirstLetter.text = String(indexNumber)
            cell.lblFirstLetter.backgroundColor = getRandomColor()
            
            cell.btnViewOrAdd.addTarget(self, action: #selector(SendData), for: .touchUpInside)
            
            return cell
        }else{
            self.cell = tblKpi_List.dequeueReusableCell(withIdentifier: "With_TargetKpiCell", for: indexPath) as! With_TargetKpiCell
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            self.designCell(cView: cell.backView)
            
            cell.lblKpi_Name.text = lcDict["kpi_name"] as? String
            cell.AchiveKpi.text = lcDict["achieved"] as? String
            cell.Target_Kpi.text = lcDict["pkd_total"] as? String
            cell.lblFirstletter.text = String(indexNumber)
            cell.lblFirstletter.backgroundColor = getRandomColor()
            cell.btnSend.tag = indexPath.row
            cell.btnViewAdd.tag = indexPath.row
            cell.btnSend.addTarget(self, action: #selector(GetApprovedRejectTraining(sender:)), for: .touchUpInside)
            
            cell.btnViewAdd.addTarget(self, action: #selector(SendData), for: .touchUpInside)
            return cell
        }
          
    }
    
    @objc func SendData(sender: UIButton)
    {
        
         let index = IndexPath(row: sender.tag, section: 0)
        
        self.vcLight = self.storyboard?.instantiateViewController(withIdentifier: "HighLowlightsVc") as! HighLowlightsVc
        
        let lcDict  = self.Msg[index.row]
        self.Kpi_id = lcDict["kpi_id"] as! String
        
        if ((self.cEmpflg == "1") && (self.cMngrflg == "1"))
        {
            self.vcLight.setId(Kk_id: self.Kpi_id, upId: self.Up_id)
            navigationController?.pushViewController(vcLight, animated: true)
        }
        else{
            self.toast.isShow("Please accept your KRA to view or add highlights, lowlight")
        }
        
     
    }
    
    func AddTarget(sender: AnyObject)
    {
        let index = IndexPath(row: sender.tag, section: 0)
        let cell: With_TargetKpiCell = self.tblKpi_List.cellForRow(at: index) as! With_TargetKpiCell
        let nIndex = sender.tag
        let lcDict = self.Msg[nIndex!]
  
        self.txtValue = cell.txtEnterTarget.text
        print(self.txtValue)
        if self.txtValue == ""
        {
            self.toast.isShow("Plese enter a Achieve Target")
            self.valid = false
        }else
        {
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure to send this KPI Target?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
                self.sendTarget(sender: sender)
            }
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
                UIAlertAction in
                self.cell.txtEnterTarget.text = ""
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
       
        
    }
    
    func sendTarget(sender: AnyObject)
    {
        let index = IndexPath(row: sender.tag, section: 0)
        let cell: With_TargetKpiCell = self.tblKpi_List.cellForRow(at: index) as! With_TargetKpiCell
        let nIndex = sender.tag
        let lcDict = self.Msg[nIndex!]
        print(txtValue)
        
        let Tpa_Status : String!
        if self.Up_id == self.LoginUp_id
        {
            Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }
        
        let Acceptparam : [String: Any] =
            [ "pkd_id" : lcDict["pkd_id"] as! String,
              "pkdi_achieved" : self.txtValue,
              "added_by" : self.Up_id,
              "up_id" : self.Up_id,
              "pkdi_status" : Tpa_Status
                
        ]
        
        print("AcceptParam", Acceptparam)
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/addAchievedKPI"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.getKpi()
            self.tblKpi_List.reloadData()
            self.toast.isShow("Your KPI have been sent")
            cell.txtEnterTarget.text = ""
            
        }
    }
    
    @objc func GetApprovedRejectTraining(sender: AnyObject)
    {
        if ((self.cEmpflg == "1") && (self.cMngrflg == "1"))
        {
            self.AddTarget(sender: sender)
        }
        else{
            
            self.toast.isShow("Please accept your KRA to add Target")
            cell.txtEnterTarget.text = ""

        }
    
    }
  
    func designCell(cView : UIView)
    {

        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    
}
