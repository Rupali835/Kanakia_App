//
//  DayCell.swift
//  MMSApp
//
//  Created by user on 15/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var btnDayUnSelect: MKButton!
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
    
    public static var identifier : String{
        return String(describing: self)
    }
    
    func SetDayData(cDay : Days)
    {
        self.lblDay.text = cDay.Day_Nm
        
    }
    
    
}
