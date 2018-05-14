//
//  DateHeaderView.swift
//  Kanakia SOP
//
//  Created by user on 17/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: DateHeaderView, section: Int)
}

class DateHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var m_CountLbl: UILabel!
    @IBOutlet weak var m_DateLbl: UILabel!
    
    var section: Int = 0
    
    weak var delegate: HeaderViewDelegate?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var item: ProfileViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            if item.rowCount == 0
            {
                self.m_DateLbl?.text = item.sectionTitle
                self.m_CountLbl.text = "No Meeting"
            }
            else{
                self.m_DateLbl?.text = item.sectionTitle
                self.m_CountLbl.text = "\(item.rowCount) Meetings"
            }
            
         //   self.m_DateLbl?.text = item.sectionTitle
          //  self.m_CountLbl.text = "Number of Meeting :  \(item.rowCount)"
        }
    }
    
}
