//
//  TrainListVc.swift
//  Kanakia SOP
//
//  Created by user on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class TrainListVc: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate
{
   
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var txtTrain: UITextView!
    @IBOutlet weak var tblTraining: UITableView!
    var Up_id : String = ""
    var Msg = [AnyObject]()
    private var toast: JYToast!
    var LoginUp_id : String = ""
    var dict : NSDictionary!
    var index : Int!
    var TptType : String!
    var DataArr = [AnyObject]()
    var tpt_Type: String!
     var valid = Bool(true)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.navigationItem.backBarButtonItem?.title = ""

        self.navigationItem.title = "Training Needs"
        self.txtTrain.delegate = self
          txtTrain.text = "Enter Training"
         index = 0
        self.TptType = "1"
        self.tblTraining.estimatedRowHeight = 80
        self.tblTraining.rowHeight = UITableViewAutomaticDimension
        
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        self.tblTraining.delegate = self
        self.tblTraining.dataSource = self
        
        
         tblTraining.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        tblTraining.register(UINib(nibName: "HighLowLightCell", bundle: nil), forCellReuseIdentifier: "HighLowLightCell")
        
        self.tblTraining.separatorStyle = .none
        getTraining()
        initUi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tblTraining.addGestureRecognizer(dismissKeyboardGesture)
        
        txtTrain.layer.cornerRadius = 5
        txtTrain.layer.borderWidth = 1.0
        txtTrain.layer.borderColor = UIColor.purple.cgColor
        txtTrain.backgroundColor = UIColor.clear
        
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        txtTrain.text = nil
        txtTrain.textColor = UIColor.black
        
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
                case "iPhone 5S","iPhone SE","iPhone 6S","iPhone 7","iPhone 8":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 250
                    }
                    break
                case "iPhone 6 Plus","iPhone 7 Plus","iPhone 8 Plus", "iPhone 6S Plus" :
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
                case "iPhone 5S","iPhone SE","iPhone 6S","iPhone 7","iPhone 8":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 250
                    }
                    break
                case "iPhone 6 Plus","iPhone 7 Plus","iPhone 8 Plus", "iPhone 6S Plus" :
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
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
    }
    
   
    @IBAction func OnSegment_Click(_ sender: Any)
    {
         index = segmentView.selectedSegmentIndex
        
        if index == 0
        {
            self.TptType = "1"
           self.GetData(nTptType:self.TptType)
            
         }else{
            self.TptType = "2"
            self.GetData(nTptType: self.TptType)
        }
        
    }
    
  
    func GetData(nTptType: String)
    {
         self.DataArr.removeAll(keepingCapacity: false)
        
        for lcDict in self.Msg
        {
            let tptType = lcDict["tpt_type"] as! String
            
            if  tptType == nTptType
            {
                self.DataArr.append(lcDict)
            }
        }
        
        self.tblTraining.reloadData()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUi() {
        toast = JYToast()
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
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    
    func getTraining()
    {
        let trnUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getTraining"
        let trnParam = [ "up_id" : self.Up_id,
                         "type" : "ios"]
        
        Alamofire.request(trnUrl, method: .post, parameters: trnParam).responseJSON { (dataAchive) in
            let data = dataAchive.result.value as! [String: AnyObject]
            self.Msg = data["msg"] as! [AnyObject]
            print("dict=",self.Msg)
            
            self.OnSegment_Click(self.segmentView)
            
          if self.Msg.count == 0
            {
                self.toast.isShow("No Any Trainings found")
            }
            
        }
    }
    
    func GetApprovedRejectTraining(nIndex: Int, nStatus: Int)
    {
        print("N_index", nIndex)
        let lcDict = self.DataArr[nIndex]
        print("lcDict", lcDict)
        let Acceptparam : [String: Any] =
            [ "tpt_status" : nStatus,
              "tpt_id" : lcDict["tpt_id"] as! String,
              "tpt_approved_by" : self.LoginUp_id
        ]
        print("Parameter", Acceptparam)
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectTraining"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
           self.getTraining()
           self.tblTraining.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArr.count
    }
    
    func SetCellData(cell: HighLowLightCell, lcDict: [String: AnyObject],indexPath: IndexPath)
    {
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        
        cell.btnAccept.isHidden = false
        cell.btnReject.isHidden = false
        
        cell.lblLightName.text = lcDict["tpt_name"] as? String
        cell.lblAddedBy.text = (lcDict["tpt_added_by_name"] as! String)
        cell.lblDateTime.text = (lcDict["tpt_added_timestamp"] as! String)
        cell.lblApprovedBy.text = (lcDict["tpt_approved_by_name"] as! String)
        
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(Accept_Click(sender:)), for: .touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(Reject_Click(sender:)), for: .touchUpInside)
        
        if (lcDict["tpt_status"] as! String) == "1"
        {
            
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
            cell.lblPersonStatus.text = "Accepted By:"
            cell.lblStatus.text = "Accepted"
            cell.backView.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)
        }
        if (lcDict["tpt_status"] as! String) == "2"
        {
            
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.lblPersonStatus.text = "Rejected By:"
            cell.lblStatus.text = "Rejected"
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
            
        }
        if (lcDict["tpt_status"] as! String) == "0"
        {
            cell.btnAccept.isHidden = false
            cell.btnReject.isHidden = false
            cell.lblStatus.text = "Pending"
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        
        let lcDict = self.DataArr[indexPath.row]
        
        if self.Up_id != LoginUp_id
        {
            
         let cell = tblTraining.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
            
            self.SetCellData(cell: cell, lcDict: lcDict as! [String : AnyObject],indexPath: indexPath)
            
        return cell
            
       }else
        {
            
            let Tpa_St = lcDict["tpt_status"] as? String
            
            if (Tpa_St == "0")
            {
                print("UpID =", self.Up_id)
                let cell = tblTraining.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                

                cell.btnDelete.isHidden = true
                cell.contentView.layer.cornerRadius = 8
                cell.contentView.layer.masksToBounds = true
                self.designCell(cView: cell.backView)
                cell.lblTime.text = (lcDict["tpt_added_timestamp"] as! String)
                cell.lblAddname.text = (lcDict["tpt_name"] as! String)
                cell.lblAdedBy.text = (lcDict["tpt_added_by_name"] as! String)
                if (lcDict["tpt_status"] as! String) == "0"
                {
                    cell.btnDelete.isHidden = false
                    cell.lblStatus.text = "Pending"
                }
                
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
                return cell
            }
            else{
                
                let cell = tblTraining.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
                
                self.SetCellData(cell: cell, lcDict: lcDict as! [String : AnyObject], indexPath: indexPath)
               
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
            let lcDict = self.DataArr[nIndex!]
            print(lcDict)
            
            let Tpa_id = lcDict["tpt_id"] as! String
            let deleteUrl = "http://kanishkagroups.com/sop/pms/index.php/API/deleteTraining"
            let deleteParam =
                [
                    "tpt_id" : Tpa_id
            ]
            Alamofire.request(deleteUrl, method: .post, parameters: deleteParam).responseJSON { (addResp) in
                print(addResp)
                self.getTraining()
                
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
        let alert = UIAlertController(title: "Alert", message: "Are you sure to accept this?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let index = sender.tag
            print("index=", index)
            self.GetApprovedRejectTraining(nIndex: index, nStatus: 1)
          //  self.toast.isShow("Successfully Accepted")
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
            self.GetApprovedRejectTraining(nIndex: index,nStatus: 2)
        //    self.toast.isShow("Successfully Rejected")
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    @IBAction func SendTraining_btnClick(_ sender: Any)
    {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Training?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.addTrainurl()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.txtTrain.text = ""
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTrainurl()
    {
        let Tpa_Status : String!
        
        if self.Up_id == self.LoginUp_id
        {
            Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }
        
        if txtTrain.text == ""
        {
            self.toast.isShow("Please enter a text")
            self.valid = false
        }else{
            let url = "http://kanishkagroups.com/sop/pms/index.php/API/addTraining"
            let param : [String: Any] =
                [        "up_id" : self.Up_id,
                         "tpt_name" : txtTrain.text,
                         "tpt_status" : Tpa_Status,
                         "tpt_added_by" : self.LoginUp_id,
                         "tpt_type" : self.TptType
            ]
            
            print("Training Parameter =", param )
            Alamofire.request(url, method: .post, parameters: param).responseJSON { (addResp) in
                print(addResp)
                self.txtTrain.text = ""
                self.getTraining()
                
            }
        }
        
    }

 
}
