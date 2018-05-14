//
//  VenueCell.swift
//  MMSApp
//
//  Created by user on 09/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class VenueCell: UICollectionViewCell
{
    
    @IBOutlet weak var lblTv: UILabel!
    @IBOutlet weak var venueImg: UIImageView!
    @IBOutlet weak var CheckMarkImg: UIImageView!
    
    @IBOutlet weak var venueLbl: UILabel!

  //  let newVenue = "Other"

func setData(room : rooms)
{
  
    venueLbl.text = room.r_Name!
    lblTv.text = room.r_tv_flag!
    
    if lblTv.text == "1"
    {
        lblTv.text = "T.V"
    }
    else
    {
        lblTv.text = ""
    }
  
}

static var identifier : String{
   return String(describing: self)
  }
    
   
}





