//
//  DocumentCell.swift
//  Kanakia SOP
//
//  Created by user on 02/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell
{
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var DocumentNamelbl: UILabel!
    @IBOutlet weak var DocumentImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(cFileDocument: FileDocument)
    {
        self.DocumentNamelbl.text = cFileDocument.DocumentName
    }
    
}
