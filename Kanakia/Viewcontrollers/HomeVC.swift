//
//  HomeVC.swift
//  MMSApp
//
//  Created by user on 15/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseDatabase
import GoogleMaps
import CoreLocation

enum ViewCtr :Int
{
    case MMSVc  = 0
    case VmsVc  = 1
    case MrmsVc = 2
    case PmsVc    = 3
}

class HomeVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate
{
    
    @IBOutlet weak var lblVms: UIButton!
    @IBOutlet weak var imgVms: UIImageView!
    @IBOutlet weak var lblMrms: UIButton!
    @IBOutlet weak var imgMrms: UIImageView!
    @IBOutlet weak var lblMms: UIButton!
    @IBOutlet weak var imgMms: UIImageView!
    @IBOutlet weak var lblPms: UIButton!
    @IBOutlet weak var imgPms: UIImageView!
    @IBOutlet weak var MmsBtn: UIButton!
    @IBOutlet weak var btnVms: MKButton!
    @IBOutlet weak var btnMrms: MKButton!
    @IBOutlet weak var BtnPms: UIButton!
    
    @IBOutlet weak var btnPreviousMap: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    
    var cChangePasswordVc : ChangePasswordVc!
    var user_active: String = ""
    var Meetingdata: [AnyObject]? = [AnyObject]()
    var PasswordValid = Bool(true)
    var strUserId : String = ""
    var enumVal: ViewCtr!
    var Up_id : String!
    var upType : String!
    var VmsStatus : String!
    var MrmsStatus : String!
    var MmsStatus : String!
    var PmsStatus : String!
    var Check = Bool(false)
    var JSonDict = [String: AnyObject]()
    var strUserName : String = ""
    var locationManager : CLLocationManager?
    var ref : DatabaseReference?
     private var toast: JYToast!
    var userDict = NSDictionary()
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        if isConnectedToNetwork()
        {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.setHidesBackButton(true, animated: false)
            
            userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
            strUserId = userDict["user_id"] as! String
            VmsStatus = userDict["user_vms_access"] as! String
            MrmsStatus = userDict["user_mrms_access"] as! String
            MmsStatus = userDict["user_mms_access"] as! String
            PmsStatus = userDict["user_pms_access"] as! String
            
            if MmsStatus == "0"
            {
                MmsBtn.isHidden = true
                imgMms.isHidden = true
                lblMms.isHidden = true
                
            }
            if VmsStatus == "0"
            {
                btnVms.isHidden = true
                imgVms.isHidden = true
                lblVms.isHidden = true
            }
            if MrmsStatus == "0"
            {
                btnMrms.isHidden = true
                imgMrms.isHidden = true
                lblMrms.isHidden = true
            }
            if PmsStatus == "0"
            {
                BtnPms.isHidden = true
                btnVms.isHidden = true
                btnVms.isHidden = true
            }
            
            
            print("User_id =", strUserId)
            user_active = userDict["user_active"] as! String
            
            let UserDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
            strUserName = UserDict["user_emp_id"] as! String
            getUserType()
            setMapBtn()
            
            initUi()
            
            
        }else{
              self.toast.isShow("No Internet Connection Available")
        }
        
    }

    private func initUi() {
        toast = JYToast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    
    override func awakeFromNib()
    {
        self.cChangePasswordVc = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVc") as! ChangePasswordVc
    }
    
    func DesignTextfield(txtField : MKTextField)
    {
        txtField.delegate         = self 
        txtField.layer.borderColor             = UIColor.clear.cgColor
        txtField.floatingLabelBottomMargin     = 4
        txtField.floatingPlaceholderEnabled    = true
        txtField.bottomBorderWidth             = 1
        txtField.bottomBorderEnabled           = true
        txtField.tintColor = UIColor.blue
        txtField.minimumFontSize = 20.0
    }
    
    func ShowAlertView(sTitile: String, cMessage: String)
    {
        let alertController = UIAlertController(title: sTitile, message: cMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
                print("OK Pressed")
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

   @IBAction func Change_PasswordBtn_Click(_ sender: Any)
    {
        self.cChangePasswordVc.view.frame = self.view.bounds
        self.view.addSubview(self.cChangePasswordVc.view)
        self.cChangePasswordVc.view.clipsToBounds = true
    }
   
    @IBAction func OnLogoutBtn_Click(_ sender: Any)
    {
        
        
        let alert = UIAlertController(title: "Alert", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let logoutUrl = "http://kanishkagroups.com/sop/android/logout.php"
            let param = ["user_id" : self.strUserId,
                         "type" : "ios"]
            print("Logout user_id =",self.strUserId)
            Alamofire.request(logoutUrl, method: .post, parameters: param).responseString { (resp) in
                print(resp)
                
                self.logout()
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
    
    @objc func logout()
    {
        if user_active == "1"
        {
            UserDefaults.standard.removeObject(forKey: "userdata")

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let navigationController = appDelegate.window?.rootViewController as! UINavigationController
            navigationController.setViewControllers([loginVC], animated: true)

        }else{

        }

    }
    
    func RechableCheck()
    {
        
        let reachabilityManager = NetworkReachabilityManager()
        let isNetworkReachable = reachabilityManager?.isReachable
        
        if isNetworkReachable!
        {
            switch self.enumVal.rawValue
            {
                case 0:
                  
                    let cMeetingRoomVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: MeetingRoomVc.storyboardID)
                    navigationController?.pushViewController(cMeetingRoomVC, animated: true)
                break
                case 1:
                    let controller = VisitorManagementVC(nibName: "VisitorManagementVC", bundle: nil) 
                    self.navigationController?.pushViewController(controller, animated: true)
                break
              case 2:
               
                let cVC = AppStoryboard.Mrms.instance.instantiateViewController(withIdentifier: ViewController.storyboardID) as! ViewController
                navigationController?.pushViewController(cVC, animated: true)
                
                break
                
            case 3:
                if self.upType == "1"
                {
                    let pmsMvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: QuickFeedbackVC.storyboardID) as! QuickFeedbackVC
                    pmsMvc.setupData(cId: self.Up_id, cUpType: self.upType)
                    navigationController?.pushViewController(pmsMvc, animated: true)
                    
                }
                
                if self.upType == "2"
                {
                    let pmsMvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: QuickFeedbackVC.storyboardID) as! QuickFeedbackVC
                    pmsMvc.setupData(cId: self.Up_id, cUpType: self.upType)
                    navigationController?.pushViewController(pmsMvc, animated: true)
                    
                }

                
                if self.upType == "3"
                {
                let pmsCvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: QuickFeedbackVC.storyboardID) as! QuickFeedbackVC
                    pmsCvc.setupData(cId: self.Up_id, cUpType: self.upType)
                navigationController?.pushViewController(pmsCvc, animated: true)
                    
                }
                if self.upType == "0"
                {
                    let pmsEmp = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: Kra_FeedbackVc.storyboardID) as! Kra_FeedbackVc
                    pmsEmp.setupData(cId: self.Up_id)
                    pmsEmp.Check = Check
                    navigationController?.pushViewController(pmsEmp, animated: true)
                }
                
            default:
                print("no match")
            }
            
        } else {
           
            self.ShowAlertView(sTitile: "Alert", cMessage: "No Internet Connection Available")
            
        }
    }
 
    @IBAction func OnMMS_Click(_ sender: Any)
    {
        self.enumVal = ViewCtr(rawValue: ViewCtr.MMSVc.rawValue)
        self.RechableCheck()
    }
    
    @IBAction func vmsClicked(_ sender: Any)
    {
        self.enumVal = ViewCtr(rawValue: ViewCtr.VmsVc.rawValue)
        self.RechableCheck()
    }
    
    @IBAction func mrmsClicked(_ sender: Any)
    {
        self.enumVal = ViewCtr(rawValue: ViewCtr.MrmsVc.rawValue)
        self.RechableCheck()
    }
    
    @IBAction func pmsClicked(_ sender: Any)
    {
        self.enumVal = ViewCtr(rawValue: ViewCtr.PmsVc.rawValue)
        self.RechableCheck()
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
            
            self.Up_id = Msg["up_id"] as! String
            self.upType = Msg["up_type"] as! String
            

        }

    }
    
    func setMapBtn()
    {
        let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/getUser"
        let param : [String : Any] = ["user_id" : self.strUserId]
        Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            let json = resp.result.value as! NSDictionary
            let userTrackAccess = json["user_liveTrack_access"] as! String
            
            UserDefaults.standard.set(userTrackAccess, forKey: "userTrackAccess")
            
            if userTrackAccess == "1"
            {
                self.btnMap.isHidden = false
                self.btnPreviousMap.isHidden = false
                
            }else{
                self.btnMap.isHidden = true
                self.btnPreviousMap.isHidden = true
            }
        }
    }
    
    @IBAction func btn7_daysCalender_Click(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyMeetingsVc") as! MyMeetingsVc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCalender_Click(_ sender: Any)
    {
        let InterfaceVC = storyboard?.instantiateViewController(withIdentifier: "InterfaceBuilderViewController") as!
        InterfaceBuilderViewController
        
        InterfaceVC.setUserId(cUserId: self.strUserId,cJSON: self.JSonDict)
        navigationController?.pushViewController(InterfaceVC, animated: true)
    }
   
  
    
    @IBAction func btnLocation_onClicked(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnPreviousMap_onClick(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LocationByDateVC") as! LocationByDateVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
