//
//  Utilitize.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 4/16/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

class Utilities
{
    static let shared: Utilities = Utilities()
    private init() {}
    var message = UILabel()
    
    func centermsg(msg: String,view: UIView)
    {
        message.text = msg
        message.translatesAutoresizingMaskIntoConstraints = false
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
        message.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(message)
        
        message.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
