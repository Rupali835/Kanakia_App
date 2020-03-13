//
//  ReminderCell.swift
//  MMSApp
//
//  Created by user on 06/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var lblReminder: UILabel!
    @IBOutlet weak var btnUnselected: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public static var identifier : String{
        return String(describing: self)
    }
    
    func SetReminderData(cReminder : reminder)
    {
        self.lblReminder.text = cReminder.re_name
    }
    
    @IBAction func onUnselected_Click(_ sender: Any) {
    }
    
}
