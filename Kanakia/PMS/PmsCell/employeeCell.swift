//
//  employeeCell.swift
//  Kanakia SOP
//
//  Created by user on 03/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol didSelectedDelegateEmpCell : class
{
    func didSelectedRow(cell: employeeCell)
}


class employeeCell: UITableViewCell
{

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var LblEmpName: UILabel!
    @IBOutlet weak var LblFirstLetter: UILabel!
      weak var delegate: didSelectedDelegateEmpCell?
    override func awakeFromNib() {
        super.awakeFromNib()
          self.selectionStyle = .none
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectedRow(_:)))
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.LblEmpName.isUserInteractionEnabled = true
        self.LblEmpName.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func didSelectedRow(_ tapGesture: UITapGestureRecognizer)
    {
        delegate?.didSelectedRow(cell: self)
    }
    
}
