//
//  RemarkActionVc.swift
//  Kanakia SOP
//
//  Created by user on 05/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

protocol HighlightLowLightDelegate: class {
    func didSelected()
}
class RemarkActionVc: UIViewController, UITextFieldDelegate, UITextViewDelegate{

    weak var delegate: HighlightLowLightDelegate?
    
    @IBOutlet weak var txtRemark: UITextView!
    
    @IBOutlet weak var txtActionPlan: UITextView!
    var Up_id : String = ""
    var fkStatus : Int!
    var fkId : String!
    private var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.txtRemark.delegate = self
        self.txtActionPlan.delegate = self
        self.txtRemark.layer.borderWidth = 1.0
        self.txtActionPlan.layer.borderWidth = 1.0
        self.txtRemark.layer.borderColor = UIColor.purple.cgColor
        self.txtActionPlan.layer.borderColor = UIColor.purple.cgColor
        let dict  = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        self.Up_id = dict["up_id"] as! String
        initUi()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }

    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                case "iPhone 5S","iPhone SE":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 60
                    }
                    
                case "iPhone 6S":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y -= 80
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
                case "iPhone 5S","iPhone SE":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 60
                    }
                
                case "iPhone 6S":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 80
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setVal(nStatus : Int, Fkid : String)
    {
        self.fkStatus = nStatus
        self.fkId     = Fkid
  //      GetApprovedRejectLights()
        
    }
    
    func GetApprovedRejectLights()
    {
       
        let AcceptLightParam : [String: Any] =
            [ "fkpi_id" : self.fkId,
              "fkpi_remark" : self.txtRemark.text,
              "fkpi_status" : self.fkStatus,
              "fkpi_approved_by" : self.Up_id,
              "fkpi_actionplan" : self.txtActionPlan.text
        ]
    
        print("Parameter", AcceptLightParam)
        let LightsUrl = "http://kanishkagroups.com/sop/pms/index.php/API/acceptRejectHighlightLowlight"
        
        Alamofire.request(LightsUrl, method: .post, parameters: AcceptLightParam).responseJSON { (AccResp) in
            print(AccResp)
            self.txtRemark.text = ""
            self.txtActionPlan.text = ""
            self.delegate?.didSelected()
            
        }
    }

    @IBAction func btnSubmit_click(_ sender: Any)
    {
        var valid = Bool(true)
        
        if self.fkStatus == 2
        {
            if self.txtActionPlan.text == ""
            {
                self.toast.isShow("Please enter a Action Plan")
                valid = false
                return
            }
            if self.txtRemark.text == ""
            {
                self.toast.isShow("Please enter a Remark")
                  valid = false
                return
            }
        }
        else if self.fkStatus == 1
        {
            if self.txtActionPlan.text == ""
            {
                self.txtActionPlan.text = "NF"
            }
            if self.txtRemark.text == ""
            {
                 self.txtRemark.text = "NF"
            }
        }
        if valid == true
        {
            GetApprovedRejectLights()
           
            
            self.view.removeFromSuperview()
        }
        
    }
    
    @IBAction func btnCancel_click(_ sender: Any)
    {
          self.view.removeFromSuperview()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
