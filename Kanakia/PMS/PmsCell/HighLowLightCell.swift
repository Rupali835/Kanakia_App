//
//  HighLowLightCell.swift
//  Kanakia SOP
//
//  Created by user on 05/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol FeedbackCellDelegate : class {
    func didSelectedFirstCell(_ sender: HighLowLightCell)
}


class HighLowLightCell: UITableViewCell {

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPersonStatus: UILabel!
    @IBOutlet weak var lblApprovedBy: UILabel!
    @IBOutlet weak var btnConst: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblLightName: UILabel!
    @IBOutlet weak var lblAddedBy: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var backView: UIView!
    
    weak var delegate : FeedbackCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
          self.selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapOnView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.backView.addGestureRecognizer(tapGesture)
    }

    @objc func tapOnView(onView gesture: UITapGestureRecognizer)
    {
        delegate?.didSelectedFirstCell(self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
