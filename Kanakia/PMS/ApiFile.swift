//
//  ApiFile.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ApiFile: UIViewController {

    
     let url1 = "http://kanishkagroups.com/sop/pms/index.php/API/getUserType"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Achievement()
    {
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/getAchievement"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/addAchievement"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectAchievement"
        
    }

    func Feedback()
    {
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/getFeedback"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectFeedback"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/addFeedback"
        
    }
    
    func Training()
    {
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/getTraining"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/approvedRejectTraining"
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/addTraining"

    }

    func KraKpi()
    {
        _ = "http://kanishkagroups.com/sop/pms/index.php/API/getKPI"

        _ = "http://kanishkagroups.com/sop/pms/index.php/API/getKRA"
    }
}
