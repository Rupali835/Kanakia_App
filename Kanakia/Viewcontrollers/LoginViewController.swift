//
//  LoginViewController.swift
//  MMSApp
//
//  Created by Prajakta Bagade on 2/14/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
//import


class LoginViewController: UIViewController, UITextFieldDelegate,KBImageViewDelegate
{
    
    
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var txtLoginName: MKTextField!
    @IBOutlet weak var txtPasssword: MKTextField!
    var iconClick : Bool!
    var Token : String!
    
    @IBOutlet weak var movingImage: KBImageView!
    var activeField        : UITextField?
    private var toast: JYToast!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
   
        self.txtPasssword.delegate = self
        self.txtLoginName.delegate = self
        iconClick = true
        initUi()
        
    //    self.Token =  UserDefaults.standard.value(forKey: "data") as! String
   //     print("Token = ", self.Token) as Any
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    private func initUi() {
        toast = JYToast()
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
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
                    case "simulator/sandbox","iPad 5","iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular" :
                        if self.view.frame.origin.y == 0
                        {
                            self.view.frame.origin.y -= 150
                        }
                        
                    break
                    
                    default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                    case "iPhone 5S","iPhone SE":
                        if self.view.frame.origin.y == 0
                        {
                            self.view.frame.origin.y -= 60
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
                case "simulator/sandbox","iPad 5","iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 150
                    }
                    break
               
                default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 60
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
   @IBAction func btnLoginClicked(_ sender: Any)
   {
        let reachabilityManager = NetworkReachabilityManager()
    
       
         let isNetworkReachable = reachabilityManager?.isReachable
    
        if isNetworkReachable!
        {
            self.setUpAPI()
        } else {
            //Internet Not Available"
            self.toast.isShow("No Internet Connection Available")
         //   self.showAlert(strMessage: "No Internet Connection Available")
        }
    
   }
    
    func setUpAPI()
    {
        let strUserName = txtLoginName.text?.removeBlankSpace()
        let strPassword = txtPasssword.text?.removeBlankSpace()
        
        if (strUserName?.isEmpty)!{
            self.toast.isShow("Please Enter User Name!")
            return
        }
        if (strPassword?.isEmpty)!{
            self.toast.isShow("Please Enter Password!")
         //   showAlert(strMessage: "Please Enter Password!")
            return
        }
        let params:[String:String] = [
            "emp_id": strUserName!,
            "password": strPassword!,
   //         "fcm_token": self.Token,
             "type" : "ios"
       ]
        
        print(params)
        let url = "http://kanishkagroups.com/sop/android/login.php"
        
        Alamofire.request(url, method: .post, parameters: params).responseJSON { (resp) in
            print(resp)
            
            if let JSON = resp.result.value{
                
                let maindict = JSON as! NSDictionary
                let responseText = maindict["responseText"] as! String
                
                
                if responseText == "SUCCESS"
                {
                    let responsdict = maindict.value(forKey: "responseArray") as! NSDictionary
                    UserDefaults.standard.set(responsdict, forKey: "userdata")
                    
                    let cMeetingRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(cMeetingRoomVC, animated: true)
                    
                }else
                {
                    self.toast.isShow("Please Enter the Correct Password")
                  //  self.showAlert(strMessage: "Please Enter the Correct Password")
                }
            
            }
            
        }
    }
    
//    func DesignTextfield(txtField : MKTextField)
//    {
//        txtField.delegate         = self
//        txtField.layer.borderColor             = UIColor.clear.cgColor
//        txtField.floatingLabelBottomMargin     = 4
//        txtField.floatingPlaceholderEnabled    = true
//        txtField.bottomBorderWidth             = 1
//        txtField.bottomBorderEnabled           = true
//        txtField.tintColor = UIColor.blue
//        txtField.minimumFontSize = 20.0
//    }

    func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }
    
    @IBAction func btnShowPassword_Click(_ sender: Any)
    {
        if(iconClick == true) {
            self.txtPasssword.isSecureTextEntry = false
            btnEye.setBackgroundImage(UIImage(named: "eye"), for: .normal)
            iconClick = false
        } else {
           self.txtPasssword.isSecureTextEntry = true
            btnEye.setBackgroundImage(UIImage(named: "hide"), for: .normal)
            iconClick = true
        }

    }
    func numberOfImages(in imageView: KBImageView!) -> UInt {
        return 1
    }
    
    func imageView(_ imageView: KBImageView!, imageFor index: UInt) -> UIImage! {
        
        return UIImage(named: String(format: "%u.jpg", index + 1))
    }
    
 
    @IBAction func hideKeyboard(_ sender: Any)
    {
        self.txtLoginName.resignFirstResponder()
        self.txtPasssword.resignFirstResponder()
    }
    
    
}
