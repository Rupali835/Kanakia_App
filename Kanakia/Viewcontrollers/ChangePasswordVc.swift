//
//  ChangePasswordVc.swift
//  Kworld
//
//  Created by user on 12/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordVc: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtConformPass: MKTextField!
    @IBOutlet weak var txtnewPass: MKTextField!
    @IBOutlet weak var ViewPassword: UIView!
    @IBOutlet weak var txtOldpass: MKTextField!
    
    private var toast: JYToast!
     var activeField        : UITextField?
 //   var cHomeVc : HomeVC!
    var PasswordValid = Bool(true)
    var strUserId : String = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.DesignTextfield(txtField: txtOldpass)
        self.DesignTextfield(txtField: txtnewPass)
        self.DesignTextfield(txtField: txtConformPass)

        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
        
        self.txtConformPass.delegate = self
        self.txtnewPass.delegate  = self
        self.txtOldpass.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        initUi()
      
    }

    private func initUi() {
        toast = JYToast()
    }

    func clearData()
    {
        self.txtOldpass.text = ""
        self.txtnewPass.text = ""
        self.txtConformPass.text = ""
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
                case "simulator/sandbox","iPad 5","iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 60
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
                        self.view.frame.origin.y += 60
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
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ChangePassword()
    {
        let passUrl = "http://kanishkagroups.com/sop/android/change_password.php"
        
        let params: [String: String] =
            [
                "user_id" : strUserId,
                "old_pass" : txtOldpass.text!,
                "new_pass" : txtnewPass.text!
        ]
        
        Alamofire.request(passUrl, method: .post, parameters: params).responseString { (RespPassword) in
            print(RespPassword)
            
            let respStr = RespPassword.result.value
            print("Result : \(String(describing: respStr))")
            self.toast.isShow(respStr!)
            return
                
            }
        
        }
        
    

  
    @IBAction func BtnCancel_OnClose(_ sender: Any)
    {
        self.view.removeFromSuperview()
        self.clearData()
    }
    
    
    @IBAction private func BtnSubmit_OnClick(_ sender: Any)
    {
        PasswordValid = true
        if (txtnewPass.text != txtConformPass.text)
        {
            let msg : String! = "Please Enter The Same Password at Confirm Password"
            self.toast.isShow(msg)
            PasswordValid = false
            return
        }
        
        if (txtOldpass.text != "") && (txtnewPass.text != "") && (txtConformPass.text == "")
        {
            self.toast.isShow("Please Enter The Confirm Password")
            PasswordValid = false
            return
        }
        if (PasswordValid == true)
        {
            self.ChangePassword()
        }
        
    }
    
    func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
    }

}
