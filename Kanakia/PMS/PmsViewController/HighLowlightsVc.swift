//
//  HighLowlightsVc.swift
//  Kanakia SOP
//
//  Created by user on 05/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class HighLowlightsVc: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,HighlightLowLightDelegate {
   
    
    @IBOutlet weak var txtLights: UITextView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tblLights: UITableView!
    var Kpi_id : String = ""
    var SegmentIndex : Int!
    var Up_id : String = ""
    var Kflag : String = ""
     private var toast: JYToast!
    var Msg = [AnyObject]()
 //   var Lowdata = [AnyObject]()
    var cRemarkVc : RemarkActionVc!
    var fkid : String!
     var LoginUp_id : String = ""
     var dict : NSDictionary!
     var valid = Bool(true)
    
    override func awakeFromNib()
    {
        self.cRemarkVc = self.storyboard?.instantiateViewController(withIdentifier: "RemarkActionVc") as! RemarkActionVc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtLights.delegate = self
        self.txtLights.text = "Enter Highlights"
         self.SegmentIndex = 0
        self.Kflag = "1"
        self.tblLights.separatorStyle = .none
        self.tblLights.delegate = self
        self.tblLights.dataSource = self
        self.tblLights.estimatedRowHeight = 80
        self.tblLights.rowHeight = UITableViewAutomaticDimension
        
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        self.LoginUp_id = self.dict["up_id"] as! String
         tblLights.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
       
         tblLights.register(UINib(nibName: "ActoinRemarkCell", bundle: nil), forCellReuseIdentifier: "ActoinRemarkCell")
        
      //  tblLights.register(UINib(nibName:), forCellReuseIdentifier: <#T##String#>)
        initUi()
       getDataFromAPI(getHighLowLights: "getHighlights")
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
        txtLights.layer.cornerRadius = 5
        txtLights.layer.borderWidth = 1.0
        txtLights.layer.borderColor = UIColor.purple.cgColor
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        txtLights.text = nil
        txtLights.textColor = UIColor.black
        
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            let model = UIDevice.current.model
            print("\(UIDevice().type.rawValue)")
            
            if model == "iPad"
            {
                switch UIDevice().type.rawValue
                {
                case "simulator/sandbox","iPad 5":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 150
                    }
                    break
                case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 100
                    }
                    break
                    
                default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE", "iPhone 6S":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 250
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            let model = UIDevice.current.model
            print("\(UIDevice().type.rawValue)")
            
            if model == "iPad"
            {
                switch UIDevice().type.rawValue
                {
                case "simulator/sandbox","iPad 5":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 150
                    }
                    
                    break
                case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                    self.view.frame.origin.y -= 100
                    break
                default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE", "iPhone 6S":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 250
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
    func setId(Kk_id : String, upId: String)
    {
        self.Kpi_id = Kk_id
        self.Up_id = upId
        print("Kpi_id, upId = \(self.Kpi_id),\(self.Up_id)")
    //    getHighlight()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    @IBAction func btnSegment_OnClick(_ sender: Any)
    {
        self.SegmentIndex = segmentView.selectedSegmentIndex
        
       self.segmentClick()
    }
    
    func segmentClick()
   {
    
    if self.SegmentIndex == 0
    {
        self.Kflag = "1"
        self.txtLights.text = "Enter Highlights"
        getDataFromAPI(getHighLowLights: "getHighlights")
    }else{
        self.Kflag = "2"
        self.txtLights.text = "Enter Lowlights"
        getDataFromAPI(getHighLowLights: "getLowlights")
     }
    
    tblLights.reloadData()
}

    
    func getDataFromAPI(getHighLowLights: String)
    {
         let achiveURL = "http://kanishkagroups.com/sop/pms/index.php/API/" + getHighLowLights
        
        let achiveParam = ["kpi_id" : self.Kpi_id,
                           "type" : "ios"]
        
        
        Alamofire.request(achiveURL, method: .post, parameters: achiveParam).responseJSON { (dataAchive) in
           print(dataAchive)
            let data = dataAchive.result.value as! [String: AnyObject]
            
            if self.Kflag == "1"
            {
                self.Msg = data["msg"] as! [AnyObject]
                if (self.Msg.count == 0)
                {
                    self.toast.isShow("No any highlights found")
                }
            }else{
                self.Msg = data["msg"] as! [AnyObject]
                if (self.Msg.count == 0)
                {
                    self.toast.isShow("No any lowlights found")
                }
            }
            
            self.tblLights.reloadData()
            
        }
    }
        
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowOpacity = 0.23
        cView.layer.shadowRadius = 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcDict = self.Msg[indexPath.row]
        let Tpa_St = lcDict["fkpi_status"] as? String
        
        if self.Up_id != LoginUp_id
        {
            let cell = tblLights.dequeueReusableCell(withIdentifier: "ActoinRemarkCell", for: indexPath) as! ActoinRemarkCell
            cell.btnAccept.isHidden = false
            cell.btnReject.isHidden = false
         
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            self.designCell(cView: cell.backView)
            cell.lblLightName.text = (lcDict["fkpi_name"] as! String)
            cell.lblAddedBy.text = (lcDict["fkpi_added_by_name"] as! String)
            cell.lblDateTime.text = (lcDict["fkpi_added_timestamp"] as! String)
            cell.lblApprovedBy.text = (lcDict["fkpi_approved_by_name"] as! String)
            cell.lblRemarkAction.text = (lcDict["fkpi_remark"] as! String)
            if cell.lblRemarkAction.text == "NF"
            {
                cell.lblRemarkAction.text = "Not Provided"
            }
           
            cell.btnAccept.tag = indexPath.row
            cell.btnReject.tag = indexPath.row
            cell.btnAccept.addTarget(self, action: #selector(Accept_Click(sender:)), for: .touchUpInside)
            cell.btnReject.addTarget(self, action: #selector(Reject_Click(sender:)), for: .touchUpInside)
            
            if (lcDict["fkpi_status"] as! String) == "1"
            {
                
                cell.btnAccept.isHidden = true
                cell.btnReject.isHidden = true
                cell.lblPersonStatus.text = "Accepted By:"
                cell.lblStatus.text = "Accepted"
                cell.backView.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)
                
                if cell.lblRemarkAction.text == "NF"
                {
                    cell.lblRemarkAction.text = "Not Provided"
                }
                
            }
            if (lcDict["fkpi_status"] as! String) == "2"
            {
                cell.btnAccept.isHidden = true
                cell.btnReject.isHidden = true
                cell.lblPersonStatus.text = "Rejected By:"
                cell.lblStatus.text = "Rejected"
                cell.backView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
            }
            if (lcDict["fkpi_status"] as! String) == "0"
            {
                cell.btnAccept.isHidden = false
                cell.btnReject.isHidden = false
                cell.lblStatus.text = "Pending"
                cell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)
                
            }
            return cell
        }else
        {
            if (Tpa_St == "0")
            {
                print("UpID =", self.Up_id)
                let cell = tblLights.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                
                let lcDict = self.Msg[indexPath.row]
                cell.btnDelete.isHidden = true
                cell.contentView.layer.cornerRadius = 8
                cell.contentView.layer.masksToBounds = true
                self.designCell(cView: cell.backView)
                cell.lblTime.text = (lcDict["fkpi_added_timestamp"] as! String)
                cell.lblAddname.text = (lcDict["fkpi_name"] as! String)
                cell.lblAdedBy.text = (lcDict["fkpi_added_by_name"] as! String)
                if (lcDict["fkpi_status"] as! String) == "0"
                {
                    cell.btnDelete.isHidden = false
                    cell.lblStatus.text = "Pending"
                }
                
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
                return cell
            }
            else{
                
                let cell = tblLights.dequeueReusableCell(withIdentifier: "ActoinRemarkCell", for: indexPath) as! ActoinRemarkCell
                
                cell.btnAccept.isHidden = true
                cell.btnReject.isHidden = true
                
                cell.contentView.layer.cornerRadius = 8
                cell.contentView.layer.masksToBounds = true
                self.designCell(cView: cell.backView)
                
                cell.lblLightName.text = lcDict["fkpi_name"] as? String
                cell.lblAddedBy.text = lcDict["fkpi_added_by_name"] as? String
                cell.lblDateTime.text = (lcDict["fkpi_added_timestamp"] as! String)
                cell.lblApprovedBy.text = (lcDict["fkpi_approved_by_name"] as! String)
             
                
                if (lcDict["fkpi_status"] as! String) == "0"
                {
                    cell.btnAccept.isHidden = false
                    cell.btnReject.isHidden = false
                    cell.lblStatus.text = "Pending"
                    cell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)
                }
                if (lcDict["fkpi_status"] as! String) == "1"
                {
                     cell.lblRemarkAction.text = (lcDict["fkpi_remark"] as! String)
                    cell.btnAccept.isHidden = true
                    cell.btnReject.isHidden = true
                    cell.lblPersonStatus.text = "Accepted By:"
                    cell.lblStatus.text = "Accepted"
                    cell.backView.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)
                    if cell.lblRemarkAction.text == "NF"
                    {
                        cell.lblRemarkAction.text = "Not Provided"
                    }
                }
                if (lcDict["fkpi_status"] as! String) == "2"
                {
                    cell.lblRemarkAction.text = (lcDict["fkpi_remark"] as! String)
                    cell.btnAccept.isHidden = true
                    cell.btnReject.isHidden = true
                    cell.lblPersonStatus.text = "Rejected By:"
                    cell.lblStatus.text = "Rejected"
                    cell.backView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
                }
             
                return cell
                
                
            }
            
        }
    }
    
    @objc func Delete_Click(sender: AnyObject)
    {
        let alert = UIAlertController(title: "Dynamic PMS", message: "Are you sure to delete this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let nIndex = sender.tag
            let lcDict = self.Msg[nIndex!]
            
            let Fkpa_id = lcDict["fkpi_id"] as! String
            let deleteUrl = "http://kanishkagroups.com/sop/pms/index.php/API/deleteHighlightLowlight"
            let deleteParam =
                [
                    "fkpi_id" : Fkpa_id
            ]
            Alamofire.request(deleteUrl, method: .post, parameters: deleteParam).responseJSON { (addResp) in
                print(addResp)
                
                self.getDataFromAPI(getHighLowLights: "getHighlights")
                self.getDataFromAPI(getHighLowLights: "getLowlights")
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }

    @objc func Accept_Click(sender:UIButton)
    {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Highlight or Lowlight?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        let index = sender.tag
       print("index=", index)
        
        let lcDict = self.Msg[index]
        self.fkid = lcDict["fkpi_id"] as! String
        
        self.cRemarkVc.view.frame = self.view.bounds
        
        if let cSelectedStr = self.fkid
        {
            self.cRemarkVc.setVal(nStatus: 1, Fkid: cSelectedStr)
        }
        
        self.cRemarkVc.delegate = self
        self.view.addSubview(self.cRemarkVc.view)
        self.cRemarkVc.view.clipsToBounds = true
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.txtLights.text = ""
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func Reject_Click(sender:UIButton)
    {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Highlight or Lowlight?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
        
       let index = sender.tag
        print("index=", index)
        
        let lcDict = self.Msg[index]
        self.fkid = lcDict["fkpi_id"] as! String
        self.cRemarkVc.view.frame = self.view.bounds
        
        if let cSelectedStr = self.fkid
        {
            self.cRemarkVc.setVal(nStatus: 2, Fkid: cSelectedStr)
        }
        self.cRemarkVc.delegate = self
        self.view.addSubview(self.cRemarkVc.view)
        self.cRemarkVc.view.clipsToBounds = true
    }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.txtLights.text = ""
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnSend_onClicked(_ sender: Any)
    {
        view.endEditing(true)
        self.addLights()
    }
    
   
    func addLights()
    {
        let Tpa_Status : String!
        if self.Up_id == self.LoginUp_id
        {
            Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }
        if txtLights.text == ""
        {
            self.toast.isShow("Please enter a text")
            self.valid = false
        }else{
            
            let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Highlight or Lowlight?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
                UIAlertAction in
                
            let addAchiveUrl = "http://kanishkagroups.com/sop/pms/index.php/API/addHighlightLowlight"
            let addParameter : [String: Any] =
                [        "up_id" : self.Up_id,
                         "kpi_id" : self.Kpi_id,
                         "fkpi_name" : self.txtLights.text,
                         "fkpi_flag" : self.Kflag,
                         "fkpi_status" : Tpa_Status,
                         "fkpi_added_by" : self.LoginUp_id
            ]
            
            Alamofire.request(addAchiveUrl, method: .post, parameters: addParameter).responseJSON { (addResp) in
                print(addResp)
                self.txtLights.text = ""
                self.btnSegment_OnClick(self.segmentView)
            }
        }
            
            let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
                UIAlertAction in
                self.txtLights.text = ""
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didSelected()
    {
        self.segmentClick()
    }
}
