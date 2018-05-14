 //
//  VisitorManagementVC.swift
//  MMSApp
//
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
 
class VisitorManagementVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var strUserId : String = ""
    var strUserName : String = ""
    var arrMeetings : [[String:String]] = [[:]]
   // let appdelegate = AppDelegate()
        private var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
        strUserName = userDict["user_emp_id"] as! String
        collectionView.isHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib (nibName: "VisitorMgmtCell", bundle: nil) , forCellWithReuseIdentifier: "VisitorMgmtCell")
        getMeetings()
        initUi()
        
        
}
    private func initUi() {
        toast = JYToast()
    }

    func getMeetings()  {
    
        weak var weakSelf = self //var should be weak

        let url = "http://kanishkagroups.com/sop/vms/index.php/Android/Visit/todays_meeting_for_user"
        let params:[String:String] = [
            "user_id": strUserId]
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (resp) in
            print(resp)
            if let JSON = resp.result.value{
                OperationQueue.main.addOperation({
                    self.arrMeetings = JSON as! [[String:String]]
                    if self.arrMeetings.count>0{
                        self.collectionView.isHidden = false
                        weakSelf?.collectionView.reloadData()
                    }else
                    {
                        self.collectionView.isHidden = true
                        let alertController = UIAlertController(title: "Title", message: "No any meeting is found", preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            return
                            
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
    }

}
extension VisitorManagementVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMeetings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VisitorMgmtCell", for: indexPath) as! VisitorMgmtCell
        cell.lblTime.text = arrMeetings[indexPath.item]["timeonly"]
   //     cell.lblPhoneNo.text = arrMeetings[indexPath.item]["v_mobile"]
        cell.LblInTime.text = arrMeetings[indexPath.item]["vd_in_time"]
        cell.lblPurpose.text = arrMeetings[indexPath.item]["vd_purpose_text"]
        cell.lblCompanyName.text = arrMeetings[indexPath.item]["v_company"]
        cell.lblVisitorName.text = arrMeetings[indexPath.item]["v_name"]
        cell.btnEndMeeting.tag = indexPath.item
        cell.btnStartMeeting.tag = indexPath.item
        cell.btnCancelMeeting.tag = indexPath.item
        
        let status = arrMeetings[indexPath.item]["vd_status"]
        
        if status == "1"{
            cell.btnStartMeeting.isHidden = false
            cell.btnCancelMeeting.isHidden = false
            cell.btnEndMeeting.isHidden = true
        }else if status == "3" {
            cell.btnStartMeeting.isHidden = true
            cell.btnCancelMeeting.isHidden = true
            cell.btnEndMeeting.isHidden = false
            }
        
        cell.btnStartMeeting.addTarget(self, action: #selector(startMeeting(sender:)), for: .touchUpInside)
        cell.btnEndMeeting.addTarget(self, action: #selector(stopMeeting(sender:)), for: .touchUpInside)
        cell.btnCancelMeeting.addTarget(self, action: #selector(cancelMeeting(sender:)), for: .touchUpInside)

        
        
        (cell as UIView).applyShadowAndRadiustoView()
        cell.bgView.layer.cornerRadius = 5
        cell.bgView.clipsToBounds = true
        //self.collectionView.reloadData()
        return cell
    }
   
    @objc func startMeeting(sender:UIButton) {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to start this Meeting ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let vd_id = self.arrMeetings[(sender as AnyObject).tag]["vd_id"]
            self.changeMeetingStatus(vd_id: vd_id!, status: "3")
            self.toast.isShow("Meeting Start Successfully")
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func stopMeeting(sender:UIButton)  {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to stop this Meeting ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let vd_id = self.arrMeetings[(sender as AnyObject).tag]["vd_id"]
            self.changeMeetingStatus(vd_id: vd_id!, status: "4")
            self.toast.isShow("Meeting End Successfully")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc  func cancelMeeting(sender:UIButton)  {
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to cancle this Meeting ?", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let vd_id = self.arrMeetings[(sender as AnyObject).tag]["vd_id"]
            self.changeMeetingStatus(vd_id: vd_id!, status: "7")
              self.toast.isShow("Meeting Cancle Successfully")
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeMeetingStatus(vd_id:String,status:String)  {
        let url = "http://kanishkagroups.com/sop/vms/index.php/Android/Visit/change_meeting_status_ios"
        let params:[String:Any] = [
            "vd_id": vd_id,
            "status":status
   //         "status_reason" : ""
        ]
        print(params)
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (addResp) in
            print(addResp)
           
            let Msg = addResp.result.value as! [String: Any]
                let dict = Msg["msg"] as! String
                if dict == "SUCCESS"
                    {
                         self.getMeetings()
                    }
            
            
        }
        
    }
}
extension VisitorManagementVC:UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfColumns:CGFloat = 1.0
        let itemSize:CGFloat = (self.collectionView.frame.size.width - ((noOfColumns + 1) * 10)) / noOfColumns
        return CGSize(width: itemSize, height: 271)
    }
}
