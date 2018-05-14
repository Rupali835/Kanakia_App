//
//  ResponceCell.swift
//  MMSApp
//
//  Created by user on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ResponceCell: UITableViewCell {

  //  @IBOutlet weak var Lbl_invitedBy: UILabel!
    @IBOutlet weak var lbl_inviteNm: UILabel!
    @IBOutlet weak var LblStart_time: UILabel!
    @IBOutlet weak var LblEnd_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public static var identifier: String
    {
        return String(describing: self)
    }
    
    func getData(invited : InvitedInfo)
    {
        self.lbl_inviteNm.text = invited.invitedNm
        self.LblStart_time.text = invited.Start_time
        self.LblEnd_time.text = invited.End_time
    }
}
