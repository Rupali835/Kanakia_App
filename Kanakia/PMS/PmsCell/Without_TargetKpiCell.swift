//
//  Without_TargetKpiCell.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class Without_TargetKpiCell: UITableViewCell {

    @IBOutlet weak var btnViewOrAdd: UIButton!
    @IBOutlet weak var back_View: UIView!
    @IBOutlet weak var lblFirstLetter: UILabel!
    @IBOutlet weak var lblKpiName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
          self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
