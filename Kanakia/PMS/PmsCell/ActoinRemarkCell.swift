//
//  ActoinRemarkCell.swift
//  Kanakia SOP
//
//  Created by user on 15/05/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ActoinRemarkCell: UITableViewCell {

    
    @IBOutlet weak var lblPersonStatus: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblLightName: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblRemarkAction: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!
    @IBOutlet weak var lblApprovedBy: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
