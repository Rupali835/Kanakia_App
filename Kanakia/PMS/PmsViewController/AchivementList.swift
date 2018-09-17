//
//  AchivementList.swift
//  Kanakia SOP
//
//  Created by user on 02/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire


class AchivementList: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
   
  
    @IBOutlet weak var txtAchivement: UITextView!
    @IBOutlet weak var lblAchivement: UILabel!
    @IBOutlet weak var myTbl: UITableView!
    var strUserName : String = ""
    var LoginUp_id : String = ""
    var Up_id : String = ""
    var Msg = [AnyObject]()
    var valid = Bool(true)
    private var toast: JYToast!
    var cellCommonCell : HighLowLightCell!
    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtAchivement.delegate = self
        txtAchivement.isScrollEnabled = false

        self.navigationItem.backBarButtonItem?.title = ""

        txtAchivement.text = "Enter Achievements"
        txtAchivement.textColor = UIColor.gray
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        
        self.myTbl.separatorStyle = .none
        self.myTbl.estimatedRowHeight = 80
        self.myTbl.rowHeight = UITableViewAutomaticDimension
        txtAchivement.textColor = UIColor.lightGray
        
        self.myTbl.dataSource = self
        self.myTbl.delegate = self
        
        myTbl.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
         myTbl.register(UINib(nibName: "HighLowLightCell", bundle: nil), forCellReuseIdentifier: "HighLowLightCell")
      
        setupData(cId: Up_id)
        
        getAchivement()
        initUi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        myTbl.addGestureRecognizer(dismissKeyboardGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
     
        txtAchivement.layer.cornerRadius = 5
        txtAchivement.layer.borderWidth = 1.0
        txtAchivement.layer.borderColor = UIColor.purple.cgColor
        txtAchivement.backgroundColor = UIColor.clear
        txtAchivement.textColor = UIColor.black
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        getAchivement()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
      
            txtAchivement.text = nil
            txtAchivement.textColor = UIColor.black
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
     @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    @objc func keyboardWillShow(notification: NSNotification)
    {
        self.txtAchivement.text = ""
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
                case "iPhone 5S","iPhone SE", "iPhone 6S","iPhone 7","iPhone 8" :
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 250
                    }
                    break
                case "iPhone 6 Plus","iPhone 7 Plus","iPhone 8 Plus":
                   if self.view.frame.origin.y == 0
                   {
                        self.view.frame.origin.y -= 280
                    }
                    break
                    
                case "iPhone X":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 300
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView)
    {
        print(txtAchivement.text)
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let EstimateSize = txtAchivement.sizeThatFits(size)
        txtAchivement.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height
            {
                constraint.constant = EstimateSize.height
            }
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
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
                case "iPhone 5S","iPhone SE","iPhone 6S","iPhone 7","iPhone 8" :
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 250
                    }
                    break
                case "iPhone 6 Plus","iPhone 7 Plus","iPhone 8 Plus":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 280
                    }
                    break
                   
                case "iPhone X":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 300
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    private func initUi() {
        toast = JYToast()
    }
    
    func setupData(cId: String)
    {
        self.Up_id = cId
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAchivement()
    {
        let achiveURL = "http://kanishkagroups.com/sop/pms/index.php/API/getAchievement"
        let achiveParam = ["up_id" : self.Up_id,
                           "type" : "ios"]
        Alamofire.request(achiveURL, method: .post, parameters: achiveParam).responseJSON { (dataAchive) in
        let data = dataAchive.result.value as! [String: AnyObject]
        self.Msg = data["msg"] as! [AnyObject]
        print("dict=",self.Msg)
        if self.Msg.count == 0
        {
            self.toast.isShow("No Any Achievemens found")
        }
        self.myTbl.reloadData()
            
            
        }
    }
   
     func SetCellData(cellCommonCell: HighLowLightCell, lcDict: [String: AnyObject],indexPath: IndexPath)
    
     {
        cellCommonCell.contentView.layer.cornerRadius = 8
        cellCommonCell.contentView.layer.masksToBounds = true
        self.designCell(cView: cellCommonCell.backView)
        
        cellCommonCell.btnAccept.isHidden = false
        cellCommonCell.btnReject.isHidden = false
        
        cellCommonCell.lblLightName.text = lcDict["tpa_name"] as? String
        cellCommonCell.lblAddedBy.text = (lcDict["tpa_added_by_name"] as! String)
        cellCommonCell.lblDateTime.text = (lcDict["tpa_added_timestamp"] as! String)
        cellCommonCell.lblApprovedBy.text = (lcDict["tpa_approved_by_name"] as! String)
        
        cellCommonCell.btnAccept.tag = indexPath.row
        cellCommonCell.btnReject.tag = indexPath.row
        cellCommonCell.btnAccept.addTarget(self, action: #selector(Accept_Click(sender:)), for: .touchUpInside)
      
          cellCommonCell.btnReject.addTarget(self, action: #selector(Reject_Click(sender:)), for: .touchUpInside)
        if (lcDict["tpa_status"] as! String) == "1"
        {
            
            cellCommonCell.btnAccept.isHidden = true
            cellCommonCell.btnReject.isHidden = true
            
            cellCommonCell.lblPersonStatus.text = "Accepted By:"
            cellCommonCell.lblStatus.text = "Accepted"
            cellCommonCell.backView.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)
        }
        if (lcDict["tpa_status"] as! String) == "2"
        {
            
            cellCommonCell.btnAccept.isHidden = true
            cellCommonCell.btnReject.isHidden = true
            
            cellCommonCell.lblPersonStatus.text = "Rejected By:"
            cellCommonCell.lblStatus.text = "Rejected"
            cellCommonCell.backView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
            
        }
        if (lcDict["tpa_status"] as! String) == "0"
        {
            cellCommonCell.btnAccept.isHidden = false
            cellCommonCell.btnReject.isHidden = false
            cellCommonCell.lblStatus.text = "Pending"
            cellCommonCell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         let lcDict = self.Msg[indexPath.row]
        let Tpa_St = lcDict["tpa_status"] as? String
        
       if (self.Up_id != LoginUp_id) || (Tpa_St == "1") || (Tpa_St == "2")
        {
            
        print("UpID =", self.Up_id)
        self.cellCommonCell = myTbl.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
        
            self.SetCellData(cellCommonCell: cellCommonCell, lcDict: lcDict as! [String : AnyObject],indexPath: indexPath)
            
       
       
        return cellCommonCell
        }
        else
        {
            if (Tpa_St == "0")
            {
                print("UpID =", self.Up_id)
                let cell = myTbl.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                
                let lcDict = self.Msg[indexPath.row]
                cell.btnDelete.isHidden = true
                cell.contentView.layer.cornerRadius = 8
                cell.contentView.layer.masksToBounds = true
                self.designCell(cView: cell.backView)
                cell.lblTime.text = (lcDict["tpa_added_timestamp"] as! String)
                cell.lblAddname.text = (lcDict["tpa_name"] as! String)
                let AddedBy = (lcDict["tpa_added_by_name"] as! String)
                cell.lblAdedBy.text = "Added By: \(AddedBy)"
                if (lcDict["tpa_status"] as! String) == "0"
                {
                    cell.btnDelete.isHidden = false
                    cell.lblStatus.text = "Status : Pending"
                }
               
                cell.backView.backgroundColor = UIColor(red:1.00, green:0.85, blue:0.73, alpha:1.0)
                cell.viewDelete.backgroundColor = UIColor(red:1.00, green:0.85, blue:0.73, alpha:1.0)
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
                return cell
            }
            else{
                
                self.cellCommonCell = myTbl.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
                
                self.SetCellData(cellCommonCell: cellCommonCell, lcDict: lcDict as! [String : AnyObject],indexPath: indexPath)
                
                return cellCommonCell
                
                
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
            
            let Tpa_id = lcDict["tpa_id"] as! String
            let deleteUrl = "http://kanishkagroups.com/sop/pms/index.php/API/deleteAchievement"
            let deleteParam =
                [
                    "tpa_id" : Tpa_id
            ]
            Alamofire.request(deleteUrl, method: .post, parameters: deleteParam).responseJSON { (addResp) in
                print(addResp)
                
                self.getAchivement()
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

    func GetApprovedRejectAchievement(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
        
        let Acceptparam : [String: Any] =
        [ "tpa_status" : nStatus,
          "tpa_id" : lcDict["tpa_id"] as! String,
          "tpa_approved_by" : self.LoginUp_id
        ]
        
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectAchievement"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.getAchivement()
            self.myTbl.reloadData()
        
    }
}
    
    
    @objc func Accept_Click(sender:UIButton)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to accept this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let index = sender.tag
            print("index=", index)
            self.GetApprovedRejectAchievement(nIndex: index,nStatus: 1)
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
   @objc func Reject_Click(sender:UIButton)
    {
        let alert = UIAlertController(title: "Alert", message: "Are you sure to reject this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let index = sender.tag
            print("index=", index)
            self.GetApprovedRejectAchievement(nIndex: index,nStatus: 2)
            
        }
      
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
  @IBAction func btnSend_onClicked(_ sender: Any)
    {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Achievement?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.addAchive()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.txtAchivement.text = ""
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   

    func addAchive()
    {
        let Tpa_Status : String!
        if self.Up_id == self.LoginUp_id
        {
           Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }
        
        if txtAchivement.text == ""
        {
            self.toast.isShow("Please enter a text")
            self.valid = false
        }else{
            let addAchiveUrl = "http://kanishkagroups.com/sop/pms/index.php/API/addAchievement"
            let addParameter : [String: Any] =
                [        "up_id" : self.Up_id,
                         "tpa_name" : txtAchivement.text,
                         "tpa_status" : Tpa_Status,
                         "tpa_added_by" : self.LoginUp_id
                 ]
            print(addParameter)
            Alamofire.request(addAchiveUrl, method: .post, parameters: addParameter).responseJSON { (addResp) in
                print(addResp)
                self.txtAchivement.text = ""
                self.getAchivement()
                
            }
        }
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.view.endEditing(true)
//    }
     
    
}
