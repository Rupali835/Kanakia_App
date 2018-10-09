//
//  GetFeedbackVc.swift
//  Kanakia SOP
//
//  Created by user on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class GetFeedbackVc: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FeedbackCellDelegate
{
   
    @IBOutlet weak var txtReply: UITextView!
    @IBOutlet var viewReply: UIView!
    @IBOutlet weak var txtFeedback: UITextView!
    @IBOutlet weak var tblFeedback: UITableView!
    var Up_id : String!
    var Msg = [AnyObject]()
    private var toast: JYToast!
    var LoginUp_id : String = ""
    var dict : NSDictionary!
     var valid = Bool(true)
     var popUp : KLCPopup!
    var FeedbackId : String = ""
    var changeDate = Date()
    var index = IndexPath()
    var checkEmp = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         popUp = KLCPopup()
        self.navigationItem.backBarButtonItem?.title = ""

        self.txtFeedback.delegate = self
        txtFeedback.text = "Enter Feedback"
        self.tblFeedback.estimatedRowHeight = 140
        self.tblFeedback.rowHeight = UITableViewAutomaticDimension

        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        
        self.tblFeedback.separatorStyle = .none
        tblFeedback.delegate   = self
        tblFeedback.dataSource = self
        tblFeedback.allowsSelection = true
        tblFeedback.separatorStyle = .none
        tblFeedback.isUserInteractionEnabled = true
        
        tblFeedback.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        
        tblFeedback.register(UINib(nibName: "HighLowLightCell", bundle: nil), forCellReuseIdentifier: "HighLowLightCell")
        
        tblFeedback.register(UINib(nibName: "FeedbackRplyCell", bundle: nil), forCellReuseIdentifier: "FeedbackRplyCell")
        
       
        getFeedback()
        initUi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
      let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tblFeedback.addGestureRecognizer(dismissKeyboardGesture)
        
        txtFeedback.layer.cornerRadius = 5
        txtFeedback.layer.borderWidth = 1.0
        txtFeedback.layer.borderColor = UIColor.purple.cgColor
        txtFeedback.backgroundColor = UIColor.clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtFeedback.text = nil
        txtFeedback.textColor = UIColor.black
        
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
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
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
                case "iPhone 5S","iPhone SE","iPhone 6S","iPhone 7","iPhone 8" :
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    

    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func getFeedback()
    {
        let getUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getFeedback"
        let FeedbackParam : [String: Any] =
            ["up_id" : self.Up_id!,
             "type" : "ios"]
        
        Alamofire.request(getUrl, method: .post, parameters: FeedbackParam).responseJSON { (dataAchive) in
            print(dataAchive)
            let data = dataAchive.result.value as! [String: AnyObject]
            
            self.Msg = data["msg"] as! [AnyObject]
            
            if self.Msg.count == 0
            {
                self.toast.isShow("No Any Feedback found")
            }else
            {
                self.tblFeedback.reloadData()
            }
            
        }
        
    }

    func setRplyCellDate(cell: FeedbackRplyCell, lcDict: [String: AnyObject], indexPath: IndexPath)
    {
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        cell.backView.backgroundColor = UIColor(red:0.55, green:0.87, blue:1.00, alpha:1.0)
        
        cell.lblRplyStr.text = (lcDict["tpf_reply"] as! String)
        let rplyFrom = lcDict["tpf_reply_by_name"] as! String
        cell.lblRplyFrom.text = "Reply from : \(rplyFrom)"
        cell.lblFeedbackStr.text = (lcDict["tpf_name"] as! String)
        let addedBy = lcDict["tpf_added_by_name"] as! String
        cell.lblFdbkAddedBy.text = "Added By : \(addedBy)"
        
        let acceptBy = lcDict["tpf_approved_by_name"] as! String
        cell.lblfdbkAccptedBy.text = "Accepted By : \(acceptBy)"
        cell.lblDate.text = (lcDict["tpf_approved_timestamp"] as! String)
        
        
    }
    
    
    
    func SetCellData(cell: HighLowLightCell, lcDict: [String: AnyObject],indexPath: IndexPath)
    {
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        
        cell.btnAccept.isHidden = false
        cell.btnReject.isHidden = false
        
        cell.lblLightName.text = lcDict["tpf_name"] as! String
        cell.lblAddedBy.text = (lcDict["tpf_added_by_name"] as! String)
        cell.lblDateTime.text = (lcDict["tpf_added_timestamp"] as! String)
      
        cell.lblApprovedBy.text = (lcDict["tpf_approved_by_name"] as! String)
        
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        cell.btnAccept.addTarget(self, action: #selector(Accept_Click(sender:)), for: .touchUpInside)
        cell.btnReject.addTarget(self, action: #selector(Reject_Click(sender:)), for: .touchUpInside)
        
        if (lcDict["tpf_status"] as! String) == "1"
        {
            
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.lblPersonStatus.text = "Accepted By:"
            cell.lblStatus.text = "Accepted"
            cell.backView.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.79, alpha:1.0)

        }
        if (lcDict["tpf_status"] as! String) == "2"
        {
            
            cell.btnAccept.isHidden = true
            cell.btnReject.isHidden = true
            
            cell.lblPersonStatus.text = "Rejected By:"
            cell.lblStatus.text = "Rejected"
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.80, blue:0.82, alpha:1.0)
            
        }
        if (lcDict["tpf_status"] as! String) == "0"
        {
            cell.btnAccept.isHidden = false
            cell.btnReject.isHidden = false
            cell.lblStatus.text = "Pending"
            cell.backView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.76, alpha:1.0)
            

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {

         let lcDict = self.Msg[indexPath.row]
         let Tpa_St = lcDict["tpf_status"] as? String
        self.FeedbackId = (lcDict["tpf_id"] as? String)!
        let repltStr = lcDict["tpf_reply"] as? String
        
        if self.Up_id != LoginUp_id
        {
            if repltStr == ""
            {
                let cell = tblFeedback.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
                cell.delegate = self
                
                self.SetCellData(cell: cell, lcDict: lcDict as! [String : AnyObject],indexPath: indexPath)
                
                return cell
            }else{
                let cell = tblFeedback.dequeueReusableCell(withIdentifier: "FeedbackRplyCell", for: indexPath) as! FeedbackRplyCell
                self.setRplyCellDate(cell: cell, lcDict: lcDict as! [String: AnyObject], indexPath: indexPath)
                return cell
            }
        
        }else
        {
            if (Tpa_St == "0")
            {
                let cell = tblFeedback.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
                
                let lcDict = self.Msg[indexPath.row]
                cell.backView.backgroundColor = UIColor(red:1.00, green:0.85, blue:0.73, alpha:1.0)
                cell.viewDelete.backgroundColor = UIColor(red:1.00, green:0.85, blue:0.73, alpha:1.0)
                cell.btnDelete.isHidden = true
                cell.contentView.layer.cornerRadius = 8
                cell.contentView.layer.masksToBounds = true
                self.designCell(cView: cell.backView)
                cell.lblTime.text = (lcDict["tpf_added_timestamp"] as! String)
                cell.lblAddname.text = lcDict["tpf_name"] as! String
                let AddedBy = (lcDict["tpf_added_by_name"] as! String)
                cell.lblAdedBy.text = "Added By: \(AddedBy)"
                
                if (lcDict["tpf_status"] as! String) == "0"
                {
                    cell.btnDelete.isHidden = false
                    cell.lblStatus.text = "Status : Pending"
                }
                
                cell.btnDelete.tag = indexPath.row
                cell.btnDelete.addTarget(self, action: #selector(Delete_Click(sender:)), for: .touchUpInside)
 
                return cell
            }
            else{
                
                if repltStr == ""
                {
                    let cell = tblFeedback.dequeueReusableCell(withIdentifier: "HighLowLightCell", for: indexPath) as! HighLowLightCell
                    cell.delegate = self
                
                    self.SetCellData(cell: cell, lcDict: lcDict as! [String : AnyObject],indexPath: indexPath)
   
                    return cell
                }else{
                    let cell = tblFeedback.dequeueReusableCell(withIdentifier: "FeedbackRplyCell", for: indexPath) as! FeedbackRplyCell
                    self.setRplyCellDate(cell: cell, lcDict: lcDict as! [String: AnyObject], indexPath: indexPath)
                   return cell
                }
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
            
            let Tpa_id = lcDict["tpf_id"] as! String
            let deleteUrl = "http://kanishkagroups.com/sop/pms/index.php/API/deleteFeedback"
            let deleteParam =
                [
                    "tpf_id" : Tpa_id
            ]
            Alamofire.request(deleteUrl, method: .post, parameters: deleteParam).responseJSON { (addResp) in
                print(addResp)
                
                self.getFeedback()
                
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
            self.GetApprovedRejectFeedback(nIndex: index, nStatus: 1)
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
            self.GetApprovedRejectFeedback(nIndex: index,nStatus: 2)
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
       
    }

   
    
    func GetApprovedRejectFeedback(nIndex: Int, nStatus: Int)
    {
        let lcDict = self.Msg[nIndex]
        
        let Acceptparam : [String: Any] =
            [ "tpf_status" : nStatus,
              "tpf_id" : lcDict["tpf_id"] as! String,
              "tpf_approved_by" : self.LoginUp_id
            //  "tpf_approved_by" :lcDict["tpf_approved_by"] as! String
        ]
        
        let StringURl = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectFeedback"
        
        Alamofire.request(StringURl, method: .post, parameters: Acceptparam).responseJSON { (AccResp) in
            print(AccResp)
            self.getFeedback()
            self.tblFeedback.reloadData()
        }
    }
    
    func addFeedback()
    {
        var Tpa_Status : String = ""
        if self.Up_id == self.LoginUp_id
        {
            Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }
        if txtFeedback.text == ""
        {
            self.toast.isShow("Please enter a text")
            self.valid = false
        }else{
            let Feedbackurl = "http://kanishkagroups.com/sop/pms/index.php/API/addFeedback"
            let Feedparam : [String : Any] =
                [ "up_id" : self.Up_id!,
                  "tpf_name" : txtFeedback.text!,
                  "tpf_status" : Tpa_Status,
                  "tpf_added_by" : self.LoginUp_id
                ]
            
            print(Feedparam)
            Alamofire.request(Feedbackurl, method: .post, parameters: Feedparam).responseJSON { (addResp) in
                
                self.txtFeedback.text = ""
                self.toast.isShow("Feedback sent to manager for verification")
                self.getFeedback()
            }
        }
       
    }

    @IBAction func sendFeedback_onClick(_ sender: Any)
    {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to send this Feedback?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.addFeedback()
        }
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel){
            UIAlertAction in
            self.txtFeedback.text = ""
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
   

    func didSelectedFirstCell(_ sender: HighLowLightCell)
    {
//        var fdAddedBy : String!
//        var upIdself : String!
//        var rplyStr : String!
        
        guard let indexpath = tblFeedback.indexPath(for: sender) else {
            return
        }
        
        let lcdict = self.Msg[indexpath.row]
        self.FeedbackId = lcdict["tpf_id"] as! String
        let fdAddedBy = lcdict["tpf_added_by"] as! String
        let upIdself = lcdict["up_id"] as! String
        let rplyStr = lcdict["tpf_reply"] as! String
        
        if (fdAddedBy != upIdself) && (rplyStr == "") && (checkEmp == true) && (self.Up_id == LoginUp_id)
        {
            popUp.contentView = viewReply
            popUp.maskType = .dimmed
            popUp.shouldDismissOnBackgroundTouch = false
            popUp.shouldDismissOnContentTouch = false
            popUp.showType = .slideInFromRight
            popUp.dismissType = .slideOutToLeft
            popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        }
    }

   @IBAction func btnSubmitRply_click(_ sender: Any)
    {
        sendRply()
    }
    
    func sendRply()
    {
       
        let rplyUrl = "http://kanishkagroups.com/sop/pms/index.php/API/addFeedbackReply"
        let param  : [String: Any] =
            [
                "tpf_id": self.FeedbackId,
                "tpf_reply" : txtReply.text!,
                "tpf_reply_by" : self.LoginUp_id ]
        print(param)
        
        Alamofire.request(rplyUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            let msgResp = resp.result.value as! [String: Any]
            let Msg = msgResp["msg"] as! String
            if Msg == "success"
            {
                self.txtReply.text = ""
                self.popUp.dismiss(true)
                self.toast.isShow("Reply sent.")
                self.getFeedback()
            }
        }
      
    }
    
    @IBAction func btnCancleRply_click(_ sender: Any)
    {
        popUp.dismiss(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}


