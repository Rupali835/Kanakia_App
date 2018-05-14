//
//  KraCell.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class KraCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var KraWeitage: UILabel!
    @IBOutlet weak var lblKraName: UILabel!
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
