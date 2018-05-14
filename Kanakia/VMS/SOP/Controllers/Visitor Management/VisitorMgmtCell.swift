//
//  VisitorMgmtCell.swift
//  MMSApp
//
// 
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class VisitorMgmtCell: UICollectionViewCell {

    
    @IBOutlet weak var btnCancelMeeting: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    @IBOutlet weak var LblInTime: UILabel!
   // @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTime: UILabel!
 //   @IBOutlet weak var lblPhoneNo: UILabel!
  //  @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnEndMeeting: UIButton!
    @IBOutlet weak var btnStartMeeting: UIButton!
    @IBOutlet weak var lblTitleCompany: UILabel!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var lblTitlePurpose: UILabel!
    @IBOutlet weak var lblVisitorName: UILabel!
    @IBOutlet weak var lblNameTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
