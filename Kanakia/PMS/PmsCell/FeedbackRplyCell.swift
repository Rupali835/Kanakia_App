//
//  FeedbackRplyCell.swift
//  Kanakia
//
//  Created by user on 23/08/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class FeedbackRplyCell: UITableViewCell {

    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblRplyStr: UILabel!
    
    @IBOutlet weak var lblRplyFrom: UILabel!
    @IBOutlet weak var lblFdbkAddedBy: UILabel!
    @IBOutlet weak var lblFeedbackStr: UILabel!
    @IBOutlet weak var lblfdbkAccptedBy: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
}
