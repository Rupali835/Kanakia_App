//
//  ViewController.swift
//  FSCalendarSwiftExample
//
//  Created by Wenchao Ding on 9/3/15.
//  Copyright (c) 2015 wenchao. All rights reserved.
//

import UIKit
import Alamofire

class InterfaceBuilderViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate,UITableViewDataSource,UITableViewDelegate,ModalControllerDelegate{
    
    @IBOutlet
    weak var calendar: FSCalendar!
    
    var cJSON: [String: AnyObject]!
     var strLocaion : String = ""
    
    @IBOutlet weak var noEventLbl: UILabel!
    @IBOutlet weak var NoEventView: UIView!
    @IBOutlet weak var eventTblView: UITableView!
    @IBOutlet
    weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate var lunar: Bool = false {
        didSet {
            self.calendar.reloadData()
        }
    }
    fileprivate let lunarFormatter = LunarFormatter()
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.calendar.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.calendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.calendar.appearance.headerDateFormat = "MMMM yyyy"
                self.calendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.darkGray
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy-MM";
                self.calendar.appearance.todayColor = UIColor.red
                self.calendar.appearance.borderRadius = 1.0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.calendar.appearance.weekdayTextColor = UIColor.red
                self.calendar.appearance.headerTitleColor = UIColor.red
                self.calendar.appearance.eventDefaultColor = UIColor.green
                self.calendar.appearance.selectionColor = UIColor.blue
                self.calendar.appearance.headerDateFormat = "yyyy/MM"
                self.calendar.appearance.todayColor = UIColor.orange
                self.calendar.appearance.borderRadius = 0
                self.calendar.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
  
    var UserId: String!
    var responseDictArr = [AnyObject]()
    private var toast: JYToast!
    
    func StringFromDate(nDate: Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: nDate)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.featchDataFromAPI(sDate: StringFromDate(nDate: Date()))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUi()
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        let lcDate = Date()
        
        self.calendar.select(self.formatter.date(from: StringFromDate(nDate: lcDate))!)
        
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        self.eventTblView.dataSource = self
        self.eventTblView.delegate = self
        
        self.eventTblView.estimatedRowHeight = 200
        self.eventTblView.rowHeight = UITableViewAutomaticDimension
        
        self.eventTblView.register(MyMeetingCell.nib, forCellReuseIdentifier: MyMeetingCell.identifier)

        self.eventTblView.layer.cornerRadius = 5
        
    }
    
    // MARK:- FSCalendarDataSource
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return self.gregorian.isDateInToday(date) ? "今天" : nil
//    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        return self.lunarFormatter.string(from: date)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2030/12/31")!
    }
    

    // MARK:- FSCalendarDelegate

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
     //   print("calendar did select date \(self.formatter.string(from: date))")
        let dateString = self.formatter.string(from: date)
        
        self.featchDataFromAPI(sDate: dateString)
        if monthPosition == .previous || monthPosition == .next
        {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let config = segue.destination as? CalendarConfigViewController {
            config.lunar = self.lunar
            config.theme = self.theme
            config.selectedDate = self.calendar.selectedDate
            config.firstWeekday = self.calendar.firstWeekday
            config.scrollDirection = self.calendar.scrollDirection
        }
    }
    
    @IBAction
    func unwind2InterfaceBuilder(segue: UIStoryboardSegue) {
        if let config = segue.source as? CalendarConfigViewController {
            self.lunar = config.lunar
            self.theme = config.theme
            self.calendar.select(config.selectedDate, scrollToDate: false)
            if self.calendar.firstWeekday != config.firstWeekday {
                self.calendar.firstWeekday = config.firstWeekday
            }
            if self.calendar.scrollDirection != config.scrollDirection {
                self.calendar.scrollDirection = config.scrollDirection
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.responseDictArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.eventTblView.dequeueReusableCell(withIdentifier: "MyMeetingCell", for: indexPath) as! MyMeetingCell
        let lcDict = self.responseDictArr[indexPath.row]
        
          cell.lblMstartTime.text = SetTimeFormat(lcTime: (lcDict["m_start_time"] as? String)!)
         cell.lblM_endTime.text = SetTimeFormat(lcTime: (lcDict["m_end_time"] as? String)!)
         cell.lblSubject.text    = lcDict["m_subject"] as? String

        let R_id : String = (lcDict["r_id"] as? String)!
        if R_id == "0"
        {
            self.strLocaion = (lcDict["m_location"] as? String)!
            cell.lblRoom.text = "External meeting : \(self.strLocaion)"
        }else{
             self.strLocaion = (lcDict["r_name"] as? String)!
            cell.lblRoom.text  = "Head office : \(self.strLocaion)"
        }
        
      
   //      self.lblMstartTime.text = SetTimeFormat(lcTime: (self.item?.m_start_time)!)
        
        return cell
    }
    
    func setupID(cUserId: String)
    {
        self.UserId = cUserId
    }
    
    func featchDataFromAPI(sDate: String)
    {
        let cParams:[String:String] = [
            "user_id": self.UserId ,
            "date": sDate
        ]
        
        print(cParams)
        let url = "http://kanishkagroups.com/sop/android/get_meeting_date_wise_ios.php"
        
        Alamofire.request(url, method: .post, parameters: cParams).responseJSON { (resp) in
            // print(resp)
            
            if let JSON = resp.result.value
            {
                
                let maindict = JSON as! [String: AnyObject]
                self.responseDictArr = maindict["data"] as! [AnyObject]
                //print("responseDictArr", self.responseDictArr)
            
                self.SetUpAPI()
                if self.responseDictArr.count == 0
                {
                    self.eventTblView.isHidden = true
                    self.NoEventView.isHidden = false
                }else{
                    self.eventTblView.isHidden = false
                    self.NoEventView.isHidden = true
                }
                
                self.eventTblView.reloadData()
        
        }
    }
}
    
    func SetUpAPI()
    {
        let modal = ModalController.sharedInstance
        modal.delegate = self
        APIManager().GetMMS()
    }
    
    func setUserId(cUserId: String, cJSON: [String: AnyObject])
    {
        self.UserId = cUserId
        self.cJSON = cJSON
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let lcDict = self.responseDictArr[indexPath.row]
        let lcMeetingFlag = lcDict["m_flag"] as! String
        let lcmOccupied = lcDict["m_occupied"] as! String
        
       //  lcRescduleMeetingVC.m_Occupied = lcDict["m_occupied"] as! String
        if lcMeetingFlag == "1"
        {
            let lcRescduleMeetingVC = storyboard?.instantiateViewController(withIdentifier: "RescduleMeetingVC") as! RescduleMeetingVC
            lcRescduleMeetingVC.m_id = lcDict["m_id"] as! String
            
            lcRescduleMeetingVC.m_cMeetingStatus = lcDict["status"] as! Int
            
            lcRescduleMeetingVC.m_Occupied = lcmOccupied
            
            lcRescduleMeetingVC.setUpData(DictData: self.cJSON)
            self.navigationController?.pushViewController(lcRescduleMeetingVC, animated: true)
        }else
        {
            self.toast.isShow("This meeting is from MRMS")
        }
    }
    
    func SetTimeFormat(lcTime: String) -> String
    {
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
    
    private func initUi()
    {
        toast = JYToast()
    }
    
    func JsonDetails(details detail: [String: AnyObject])
    {
        self.cJSON = detail
    }
}
