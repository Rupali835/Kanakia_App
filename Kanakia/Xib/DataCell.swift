//
//  DataCell.swift
//  MMSApp
//
//  Created by user on 05/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!
   // @IBOutlet weak var lbl_Id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        //self.lbl_Id.isHidden = true
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

    func SetRoomData(cRoom : rooms)
    {
        self.lblName.text = cRoom.r_Name
       // self.lbl_Id.text = cRoom.r_id
        
    }
    func SetBussinesData(cLabel : label)
    {
        self.lblName.text = cLabel.l_name
       // self.lbl_Id.text = cLabel.l_id
        
    }
    
    func SetData(cname : String)
    {
        self.lblName.text = cname
        //self.lbl_Id.text = cname
        
    }
    
    func SetGroupData(cGroup : group)
    {
        self.lblName.text = cGroup.g_name
       // self.lbl_Id.text = cGroup.g_id
    }
    
    func setMeetingWith(cMeetWith: MeetWith)
    {
        self.lblName.text = cMeetWith.m_With
    }
    
    func setMeetType(cMeetType: MeetType)  {
        self.lblName.text = cMeetType.m_Type
    }
    
    
}
