//
//  FileCellVc.swift
//  Kanakia SOP
//
//  Created by user on 28/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class FileCellVc: UITableViewCell {

    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileTime: UILabel!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
