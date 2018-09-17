//
//  NotificationRedirect.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 9/10/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class NotificationRedirect: UIViewController {

    var titleNotification : String!
    let appDel = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    func setTitle(title : String)
    {
        self.titleNotification = title
    }
  

}
