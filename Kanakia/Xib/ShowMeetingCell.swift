//
//  ShowMeetingCell.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 4/16/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ShowMeetingCell: UITableViewCell {

    @IBOutlet weak var lblSrNo: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblUserNm: UILabel!
    @IBOutlet weak var lblSetRoomOrLocation: UILabel!
    @IBOutlet weak var lblLocationOrRoom: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
