//
//  UserCell.swift
//  MMSApp
//
//  Created by user on 10/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(cuserName : String)
    {
        self.lblUserName.text = cuserName
    }
    
    

}
