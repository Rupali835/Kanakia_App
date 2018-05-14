//
//  teamCell.swift
//  Kanakia SOP
//
//  Created by user on 26/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol didSelectedDelegate : class
{
    func didSelectedRow(cell: teamCell)
}

class teamCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblEmpName: UILabel!
    @IBOutlet weak var lblFirstLetter: UILabel!
    weak var delegate: didSelectedDelegate?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
       // #selector(self.handleTap(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectedRow(_:)))
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.lblEmpName.isUserInteractionEnabled = true
        self.lblEmpName.addGestureRecognizer(tapGesture)
    }
   @objc func didSelectedRow(_ tapGesture: UITapGestureRecognizer)
    {
        print("called")
        delegate?.didSelectedRow(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
