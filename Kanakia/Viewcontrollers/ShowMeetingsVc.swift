//
//  ShowMeetingsVc.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 4/15/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ShowMeetingsVc: UIViewController, SearchMeetingProtocol
{

    @IBOutlet weak var tblMeetings: UITableView!
    var m_cMeetingsArr = [AnyObject]()
    var ColorArr = [UIColor]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblMeetings.register(UINib(nibName: "ShowMeetingCell", bundle: nil), forCellReuseIdentifier: "ShowMeetingCell")
        tblMeetings.delegate = self
        tblMeetings.dataSource = self
        tblMeetings.separatorStyle = .none
        
          self.ColorArr = [UIColor.MKColor.Red.P400, UIColor.MKColor.Blue.P400, UIColor.MKColor.Orange.P400, UIColor.MKColor.Green.P400, UIColor.MKColor.Indigo.P400, UIColor.MKColor.Amber.P400, UIColor.MKColor.LightBlue.P400, UIColor.MKColor.BlueGrey.P400, UIColor.MKColor.Brown.P400, UIColor.MKColor.Cyan.P400, UIColor.MKColor.Teal.P400, UIColor.MKColor.Lime.P400, UIColor.MKColor.Pink.P400, UIColor.MKColor.Purple.P400]
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if m_cMeetingsArr.count != 0
        {
            tblMeetings.reloadData()
             Utilities.shared.centermsg(msg: "", view: self.view)
        }else
        {
            print("No meetings found")
            Utilities.shared.centermsg(msg: "No meetings found", view: self.view)
        }
        
    }
    
    func moveToback(meetingArr: [AnyObject])
    {
        self.m_cMeetingsArr = meetingArr
        tblMeetings.reloadData()
    }
    
    @IBAction func btnSearchHere_onClick(_ sender: Any)
    {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SearchAllMeetingsVc") as! SearchAllMeetingsVc
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
        cView.backgroundColor = UIColor.white
    }
    
    func convertDateFormaterInList(cdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: cdate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return  dateFormatter.string(from: date!)
    }

}
extension ShowMeetingsVc : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Total meetings : \(self.m_cMeetingsArr.count)")
        return self.m_cMeetingsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblMeetings.dequeueReusableCell(withIdentifier: "ShowMeetingCell", for: indexPath) as! ShowMeetingCell
        let lcdict = m_cMeetingsArr[indexPath.row]
        let Cdate = (lcdict["m_date"] as! String)
        cell.lbldate.text = convertDateFormaterInList(cdate: Cdate)
        cell.lblUserNm.text = (lcdict["user_name"] as! String)
        cell.lblSubject.text = (lcdict["m_subject"] as! String)
        let Number = (lcdict["sr_no"] as! Int)
        cell.lblSrNo.text = String(Number)
        
        if let room = lcdict["r_name"] as? String
        {
            cell.lblSetRoomOrLocation.text = "Room:"
            cell.lblLocationOrRoom.text = room
        }
        
        let Location = lcdict["m_location"] as? String
        if Location != ""
        {
            cell.lblSetRoomOrLocation.text = "Location:"
            cell.lblLocationOrRoom.text = Location
        }
        let randomColor = ColorArr[Int(arc4random_uniform(UInt32(ColorArr.count)))]
        cell.lblSrNo.backgroundColor = randomColor
        designCell(cView: cell.backview)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
