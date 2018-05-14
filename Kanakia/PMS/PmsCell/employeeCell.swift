//
//  employeeCell.swift
//  Kanakia SOP
//
//  Created by user on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class employeeCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var LblEmpName: UILabel!
    @IBOutlet weak var LblFirstLetter: UILabel!
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
