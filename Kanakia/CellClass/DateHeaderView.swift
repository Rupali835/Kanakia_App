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
            
            let dateStr = item.sectionTitle
            if item.rowCount == 0
            {
                //let dateStr = item.sectionTitle
                self.m_DateLbl?.text = dateFormate(dateStr: dateStr)
                self.m_CountLbl.text = "No Meeting"
            }
            else{
                self.m_DateLbl?.text = dateFormate(dateStr: dateStr)
                self.m_CountLbl.text = "\(item.rowCount) Meetings"
            }
        
        }
    }
    
  func dateFormate(dateStr: String)-> String?
  {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd MMM yyyy (EEEE)"//"MMM dd,yyyy"
    
    if let date = dateFormatterGet.date(from: dateStr)
    {
        print(dateFormatterPrint.string(from: date))
        let dateStr = dateFormatterPrint.string(from: date)
        return dateStr
    }
    else {
        print("There was an error decoding the string")
    }
    
    return nil
  }
    
}
