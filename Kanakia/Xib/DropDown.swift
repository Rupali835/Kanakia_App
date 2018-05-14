
//
//  DropDown.swift
//  MMSApp
//
//  Created by user on 04/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class DropDown: UIView,UITableViewDelegate,UITableViewDataSource
{
   
    @IBOutlet var dropDownView  : UIView!
    @IBOutlet weak var tblView  : UITableView!
    @IBOutlet weak var mainView : UIView!
    
   var TestArr = ["ABC", "XYX","Room1","Room","ABC", "XYX","Room1","Room","ABC", "XYX","Room1","Room"]
    
    //var AddMeetArr = [rooms]()
   //  var meetingRoomsArr    = [rooms]()
   // var MeetRooms = MeetingRoomVc()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func ArrayPass()
    {
    //    self.AddMeetArr = self.meetingRoomsArr
    }
    
    func setup() {
        UINib(nibName: "DropDown", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(dropDownView)
        dropDownView.frame = self.bounds
        dropDownView.layer.shadowOpacity = 0.7
        dropDownView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        dropDownView.layer.shadowRadius  = 15.0
        dropDownView.layer.shadowColor   = UIColor.black.cgColor
        dropDownView.layer.cornerRadius  = 4
        dropDownView.layer.masksToBounds = false
        tblView.backgroundColor = UIColor.white
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print(self.TestArr.count)
        return self.TestArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = self.tblView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            
        }
        cell?.textLabel?.text = self.TestArr[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
}
