//
//  ManagerLoginFirstVc.swift
//  Kanakia
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ManagerLoginFirstVc: UIViewController {

    var Up_id : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

   
    func setupData(cId: String)
    {
        self.Up_id = cId
        print("id", self.Up_id)
    }

}
