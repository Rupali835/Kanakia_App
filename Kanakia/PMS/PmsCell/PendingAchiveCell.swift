//
//  PendingAchiveCell.swift
//  Kanakia SOP
//
//  Created by user on 10/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PendingAchiveCell: UITableViewCell {

    @IBOutlet weak var TrainType: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var btnReject: MKButton!
    @IBOutlet weak var btnAccept: MKButton!
    @IBOutlet weak var lblMainInfo: UILabel!
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblChangeNm: UILabel!
    @IBOutlet weak var backView: UIView!
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
