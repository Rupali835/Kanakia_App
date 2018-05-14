//
//  With_TargetKpiCell.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class With_TargetKpiCell: UITableViewCell {

    @IBOutlet weak var lblFirstletter: UILabel!
    @IBOutlet weak var btnViewAdd: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtEnterTarget: UITextField!
    @IBOutlet weak var AchiveKpi: UILabel!
    @IBOutlet weak var Target_Kpi: UILabel!
    @IBOutlet weak var lblKpi_Name: UILabel!
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
