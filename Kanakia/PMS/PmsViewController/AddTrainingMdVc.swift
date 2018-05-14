//
//  AddTrainingMdVc.swift
//  Kanakia SOP
//
//  Created by user on 16/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class AddTrainingMdVc: UIViewController
{

    @IBOutlet weak var txtAddTraining: UITextView!
    @IBOutlet weak var btnTechnical: UIButton!
    @IBOutlet weak var btnRadioTech: UIButton!
    @IBOutlet weak var btnRadioBehav: UIButton!
    @IBOutlet weak var btnBehaviral: UIButton!
    
    var User_id : String!
    var up_id : String!
    var Tpt_Type : String!
    private var toast: JYToast!
    var valid = Bool(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        txtAddTraining.layer.cornerRadius = 5
        txtAddTraining.layer.borderWidth = 1.0
        txtAddTraining.layer.borderColor = UIColor.purple.cgColor
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    //Calls this function when the tap is recognized.
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
   
    func setId(nStatus : String, Tpid : String)
    {
        self.User_id = nStatus
        self.up_id = Tpid
    }

    
    @IBAction func btnTech_OnClick(_ sender: Any)
    {
        self.Tpt_Type = "1"
        btnRadioTech.setImage(UIImage(named:"radiobutton_selected"), for: .normal)
        btnRadioBehav.setImage(UIImage(named:"radiobuttom_unselected"), for: .normal)
    }
    
    @IBAction func btnBehav_OnClick(_ sender: Any)
    {
         self.Tpt_Type = "2"
          btnRadioBehav.setImage(UIImage(named:"radiobutton_selected"), for: .normal)
         btnRadioTech.setImage(UIImage(named:"radiobuttom_unselected"), for: .normal)
    }
    
    @IBAction func btnSend_OnClick(_ sender: Any)
    {
        if txtAddTraining.text == ""
        {
            self.toast.isShow("Please enter a text")
            self.valid = true
        }
        else{
            
            let Tpa_Status : String!
            if self.up_id == self.User_id
            {
                Tpa_Status = "0"
            }else
            {
                Tpa_Status = "1"
            }
            
           if self.valid == true
            {
                let url = "http://kanishkagroups.com/sop/pms/index.php/API/addTraining"
                let param : [String: Any] =
                    [        "up_id" : self.User_id,
                             "tpt_name" : txtAddTraining.text,
                             "tpt_status" : Tpa_Status,
                             "tpt_added_by" : self.up_id,
                             "tpt_type" : self.Tpt_Type
                ]
                
                print("Param =", param)
                Alamofire.request(url, method: .post, parameters: param).responseJSON { (addResp) in
                    print(addResp)
                    self.txtAddTraining.text = ""
                    self.view.removeFromSuperview()
                    self.toast.isShow("Your message has been sent")
                    
                    
                }
            }
        }
       
    }
    
}
