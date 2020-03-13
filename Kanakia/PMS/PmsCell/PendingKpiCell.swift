//
//  PendingKpiCell.swift
//  Kanakia SOP
//
//  Created by user on 10/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PendingKpiCell: UITableViewCell {

 //   @IBOutlet weak var totalAchieve: UILabel!
    @IBOutlet weak var btnReject: MKButton!
    @IBOutlet weak var btnAccept: MKButton!
    @IBOutlet weak var lblAchievedData: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblKpiNm: UILabel!
    @IBOutlet weak var lblKraNm: UILabel!
    @IBOutlet weak var lblEmpNm: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
          self.selectionStyle = .none
        // Initialization code
        backView.layer.cornerRadius = 5
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
