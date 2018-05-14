//
//  MyMeetingCell.swift
//  MMSApp
//
//  Created by user on 15/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class MyMeetingCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    //  @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblM_endTime: UILabel!
    @IBOutlet weak var lblMstartTime: UILabel!
    @IBOutlet weak var lblRoom: UILabel!
    
    var strRoom : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.dropShadow(cView: backView)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dropShadow(cView : UIView) {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    public static var nib: UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public static var identifier: String
    {
        return String(describing: self)
    }

    var item: MeetingDetails? {
        didSet {
            guard let item = item else {
                return
            }
           
            if item.r_id == "0"
            {
                self.strRoom = item.m_location!
                self.lblRoom.text = "External meeting : \(self.strRoom)"
            }
            else
            {
                self.strRoom = item.r_name!
                self.lblRoom.text = "Head office : \(self.strRoom)"
            }
            self.lblSubject.text = item.m_subject
            self.lblMstartTime.text = SetTimeFormat(lcTime: (self.item?.m_start_time)!)//item.m_start_time =
            self.lblM_endTime.text =  SetTimeFormat(lcTime: (self.item?.m_end_time)!)//item.m_end_time
           
        }
    }
 
    func SetTimeFormat(lcTime: String) -> String
    {
        //let dateString = "8:22"
        print("Time=", lcTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        
        let date = formatter.date(from: lcTime)
        formatter.timeStyle = .short
        print("date: \(date!)") // date: 2014-10-09 14:22:00 +0000
        
        formatter.dateFormat = "H:mm:ss"
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        let formattedDateString = formatter.string(from: date!)//formatter.stringFromDate(date!)
        print("formattedDateString: \(formattedDateString)")
        
        return formattedDateString
    }
}
