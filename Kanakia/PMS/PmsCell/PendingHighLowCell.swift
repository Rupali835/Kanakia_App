//
//  PendingHighLowCell.swift
//  Kanakia SOP
//
//  Created by user on 10/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PendingHighLowCell: UITableViewCell {

    @IBOutlet weak var btnRejectLgt: MKButton!
    @IBOutlet weak var btnAcceptLight: MKButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var NameLight: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var KraNm: UILabel!
    @IBOutlet weak var KpiNm: UILabel!
    @IBOutlet weak var lblLightNm: UILabel!
    @IBOutlet weak var lblEmpNm: UILabel!
    @IBOutlet weak var lblChangeNm: UILabel!
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
