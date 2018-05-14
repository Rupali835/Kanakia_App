//
//  CommonCell.swift
//  Kanakia SOP
//
//  Created by user on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CommonCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var LblmainInfo: UILabel!
    @IBOutlet weak var lblAddedByName: UILabel!
    @IBOutlet weak var btnApproved: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
