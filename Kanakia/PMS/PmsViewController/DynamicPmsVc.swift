//
//  DynamicPmsVc.swift
//  Kanakia SOP
//
//  Created by user on 13/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DynamicPmsVc: UIViewController {
    var Up_id : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func BtnDynamicPms_Click(_ sender: Any)
    {
        let empVc = storyboard?.instantiateViewController(withIdentifier: "MdLoginVc") as! MdLoginVc
        empVc.setupData(cId: self.Up_id)
        navigationController?.pushViewController(empVc, animated: true)
    }
    
    @IBAction func btnQuickFeedback(_ sender: Any)
    {
       let addEmp = storyboard?.instantiateViewController(withIdentifier: "QuickFeedbackVC") as! QuickFeedbackVC
    //    addEmp.setupData(cId: self.Up_id, cUpType: <#String#>)
        navigationController?.pushViewController(addEmp, animated: true)
    }
    
    @IBAction func btnMdPendingApproval(_ sender: Any)
    {
      
    }
    
    
    
}
