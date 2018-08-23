

import UIKit
import Alamofire


class AddMeetingVc: UIViewController,UITextFieldDelegate,SelectedStringDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ModalControllerDelegate
{
    @IBOutlet weak var txtSubject       : UITextField!
    @IBOutlet weak var txtMeetingLabel  : UITextField!
    @IBOutlet weak var txtDate          : UITextField!
    @IBOutlet weak var txtDay           : UITextField!
    @IBOutlet weak var txtStartTime     : UITextField!
    @IBOutlet weak var txtEndTime       : UITextField!
    @IBOutlet weak var txtMeetWith      : UITextField!
    @IBOutlet weak var txtMeetType      : UITextField!
    @IBOutlet weak var txtRoom          : UITextField!
    @IBOutlet weak var btndropdownRooms : MKButton!
    @IBOutlet weak var txtGroups        : UITextField!
    @IBOutlet weak var txtInternalusers : UITextField!
    @IBOutlet weak var txtOtherGrp      : UITextField!
    @IBOutlet weak var txtInvitedBy     : UITextField!
    @IBOutlet weak var BtnReaptOnDayOutlet: MKButton!
    @IBOutlet weak var tblTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var AllDayUncheckbtn : UIButton!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblView          : UITableView!
    @IBOutlet weak var ContentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var txtViewAgenda    : UITextView!
    @IBOutlet weak var ContentView      : UIView!
    @IBOutlet weak var viewHgtEndDate: NSLayoutConstraint!
    @IBOutlet weak var viewReminder: UIView!
    @IBOutlet weak var grpDropDown: UIButton!
    @IBOutlet weak var meetWithDropdown: UIButton!
    @IBOutlet weak var meetTypeDropDown: MKButton!
    //  @IBOutlet weak var txtRoomsHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var txtEnddate       : UITextField!
    @IBOutlet weak var btnUnCheckBox    : UIButton!
    @IBOutlet weak var AddmeetView      : UIView!
    @IBOutlet weak var btnReoccurance   : UIButton!
    @IBOutlet weak var btnReminder      : UIButton!
    @IBOutlet weak var btnCheckbox          : UIButton!
    @IBOutlet weak var btnBussingDropDown   : UIButton!
    @IBOutlet weak var txtRepeatOn: UITextField!
    @IBOutlet weak var lblRdMontly: MKButton!
    @IBOutlet weak var lblRdweekly: MKButton!
    @IBOutlet weak var ViewReocHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblrdDaily: MKButton!
    @IBOutlet weak var btnRadoiMonthly: UIButton!
    @IBOutlet weak var btnRadioWeekly: UIButton!
    @IBOutlet weak var btnRadioDaily: UIButton!
    @IBOutlet weak var viewReoccurance: UIView!
    @IBOutlet weak var AddmeetingScrollView: SPKeyBoardAvoiding!
    @IBOutlet weak var lblBussessmeetingType: UILabel!
    @IBOutlet weak var lblMeetingRoom: UILabel!
    @IBOutlet weak var lblReptOnDay: UIButton!
    @IBOutlet weak var lblEndDate: UILabel!
    //   @IBOutlet weak var ViewOccHightConst: NSLayoutConstraint!
    
    var DayArr          = [Days]()
    var reidArr = [String]()
    var drowDownView       : DropDown!
    var upBtn              = UIButton()
    var bStatus            = Bool(false)
    var ReminderArr        = [reminder]()
    var daysArr           = [Days]()
    var cDropDownVc        : DropDownVC!
    var bCheckboxStatus    = true
    var kbHeight           : CGFloat!
    var activeField        : UITextField?
    var name: String = ""
    var result: String = ""
    var bSelected = Bool(false)
    var bAllDayunchek = Bool(false)
    var btnCheckBoxReoccur = Bool(false)
    var bInoneItem = Bool(false)
    var selectedRoomId: String!
    var NumDay : Int!
    var meetingRoomsArr = [rooms]()
    var lblBussinessArr = [label]()
    var lblReminderArr = [reminder]()
    var lblDaysArr  = [Days]()
    var lblGroupArr = [group]()
    var SelectedRoomStr : String!
    var tagVal = Int(0)
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr : String!
    var DateEndStr : String!
    var meetR_id : String!
    var bCheckReminderStatus = Bool(false)
    var bCheckweeklyStatus = Bool(false)
    var bCheckMonthStatus = Bool(false)
    var bReoccuranceStatus = Bool(false)
    var userInfoArr = NSMutableArray()
    var FilteredArr = NSArray()
    var FilteredForArr = NSArray()
    var SelectedArr = NSMutableArray()
    var bStausField: Bool!
    var jsoninterUserArr: String!
    var lcUserArr = [String]()
    var cUserArr = [user]()
    var cMeetingParamList = MeetingParamList()
    var idArr = [String]()
    var bMeetingStatus = Bool(false)
    var Meetingdata: [AnyObject]? = [AnyObject]()
    var m_id : String!
    var DictData = [String: AnyObject]()
    var DaySelectedId = [String]()
    var strUserId:String = ""
     var formValid = Bool(true)
    var NameArr = [String]()
    private var toast: JYToast!
    
    var SelectedDate: Date!
    
    override func awakeFromNib()
    {
        self.cDropDownVc = self.storyboard?.instantiateViewController(withIdentifier: "DropDownVC") as! DropDownVC
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.txtRoom.text = self.SelectedRoomStr
        self.txtViewAgenda.delegate  = self
        self.txtDate.delegate        = self
        self.txtDay.delegate         = self
        self.txtStartTime.delegate   = self
        self.txtEndTime.delegate     = self
        self.txtRoom.delegate        = self
        self.txtRepeatOn.delegate    = self
        self.tblView.delegate        = self
        self.tblView.dataSource      = self
        self.txtInternalusers.delegate    = self
        self.txtMeetingLabel.delegate = self
        self.txtMeetWith.delegate    = self
        self.txtMeetType.delegate    = self
        self.txtEnddate.delegate     = self
 //       self.txtRepeatOn.delegate   = self
        self.txtOtherGrp.delegate   = self
        self.txtInvitedBy.delegate  = self
        self.txtGroups.delegate     = self
        self.txtSubject.delegate    = self
        
        
       self.ContentViewHeightConst.constant = 1200
       self.viewHgtEndDate.constant = 100
       // self.txtGroups.isUserInteractionEnabled = false
       
        
        AddmeetView.layer.shadowOpacity = 1.0
        AddmeetView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        AddmeetView.layer.shadowRadius  = 15.0
        AddmeetView.layer.shadowColor   = UIColor.white.cgColor
        AddmeetView.layer.cornerRadius  = 4
        AddmeetView.layer.masksToBounds = false
     
       self.ViewReocHeightConst.constant = 0
       self.showHideControls(bStatus: true)
       // self.ShowHideTxt(bstatus: true)
        self.tblViewHeightConst.constant  = 0
       
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
        
        self.DayArr.append(Days(sDayName: "Sunday", dayid: "1", bselected: false))
        self.DayArr.append(Days(sDayName: "Monday", dayid: "2", bselected: false))
        self.DayArr.append(Days(sDayName: "Tuesday", dayid: "3", bselected: false))
        self.DayArr.append(Days(sDayName: "Wendsday", dayid: "4", bselected: false))
        self.DayArr.append(Days(sDayName: "Thursday", dayid: "5", bselected: false))
        self.DayArr.append(Days(sDayName: "Friday", dayid: "6", bselected: false))
        self.DayArr.append(Days(sDayName: "Saturday", dayid: "7", bselected: false))

        fetchMeetings()
       initUi()
        
    self.txtMeetingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didlblTapHeader)))
    self.txtMeetWith.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtMeetWith)))
      self.txtMeetType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtMeetType)))
    self.txtGroups.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtGroup)))
        self.txtRoom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtRoom)))
    self.txtRepeatOn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtReaptOn)))
 }
   
    private func initUi() {
        toast = JYToast()
    }
    
    @objc private func didtxtGroup()
    {
        self.view.endEditing(true)
        self.OnGroup_Click(grpDropDown)
    }
    @objc private func didtxtMeetType()
    {
        self.view.endEditing(true)
        self.OnMeetType_Click(meetTypeDropDown)
    }
    @objc private func didtxtMeetWith()
    {
        self.view.endEditing(true)
        self.onmeetWith_Clikc(meetWithDropdown)
    }
    @objc private func didlblTapHeader()
    {
         self.view.endEditing(true)
       self.OnBussinessbtn_Click(btnBussingDropDown)
    }
    
    func UserIntraction(bStatus: Bool)
    {
        txtRoom.isUserInteractionEnabled = bStatus
    }
    func fetchMeetings()
    {
        let urlString = "http://kanishkagroups.com/sop/android/getUserMeetingMms_IOS.php"
         let parameteres = ["user_id" : self.strUserId]
        print(parameteres)
        Alamofire.request(urlString, method: .post, parameters: parameteres, encoding: URLEncoding.default, headers: nil).responseJSON { (resp) in
           // print(resp)
            
            switch resp.result {
            case .failure( _):
            
                return
                
            case .success( _):
                
                _ = resp.value as! [AnyObject]
              
            //    default:print("default value");
                }
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        bSelected = false
        bAllDayunchek = false
        btnCheckBoxReoccur = false
        bCheckweeklyStatus = false
        bCheckMonthStatus = false
        bReoccuranceStatus = false
        self.bCheckReminderStatus = false
        cMeetingParamList.m_reminder_flag = "0"
        cMeetingParamList.m_reoccurrence_flag = "0"
        cMeetingParamList.m_week_no = "NF"
        cMeetingParamList.m_week_day = "NF"
        cMeetingParamList.r_id = self.selectedRoomId
        lcUserArr.removeAll(keepingCapacity: false)
        cMeetingParamList.m_reoccurrence_type = "0"
        self.ClearData()
       
    }
    func ClearData()
    {
      self.txtSubject.text = ""
        self.txtDay.text = ""
        self.txtDate.text = ""
        self.txtStartTime.text = ""
        self.txtEnddate.text = ""
        self.txtRoom.text = ""
        self.txtViewAgenda.text = ""
        self.txtGroups.text = ""
        self.txtOtherGrp.text = ""
        self.txtInternalusers.text = ""
        self.txtInvitedBy.text = ""
        self.txtEnddate.text = ""
        self.txtMeetType.text = ""
        self.txtMeetWith.text = ""
        self.lblMeetingRoom.text = ""
        self.txtEndTime.text = ""
       
    }
    
    func MeetingDetails(Details: [AnyObject])
    {
        self.Meetingdata = Details
    }
    func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
   func ParamList()
    {
        cMeetingParamList.m_other_user = txtOtherGrp.text
        cMeetingParamList.m_subject = txtSubject.text
        cMeetingParamList.m_day = txtDay.text
        cMeetingParamList.m_agenda = txtViewAgenda.text
        cMeetingParamList.m_end_after_days = "NF"
       // cMeetingParamList.m_week_day = NumDay
   //     cMeetingParamList.m_week_day = txtRepeatOn.text
        
       
        if (txtEnddate.text?.isEmpty)!
        {
            cMeetingParamList.m_end_by_date = ""
        }
        
        if (txtInternalusers.text?.isEmpty)!
        {
            cMeetingParamList.m_internal_user = "NF"
        }
        if (txtOtherGrp.text?.isEmpty)!
        {
            cMeetingParamList.m_other_user = "NF"
        }
     
        if (txtGroups.text?.isEmpty)!
        {
            cMeetingParamList.g_id = "NF"
        }

        if cMeetingParamList.m_reminder_flag == "0"
        {
            cMeetingParamList.re_id = "NF"
        }
        
        if cMeetingParamList.m_reoccurrence_flag == "0"
        {
            cMeetingParamList.m_week_day = "NF"
            cMeetingParamList.m_week_no = "NF"
        }

        if AllDayUncheckbtn.isSelected == false
        {
            cMeetingParamList.m_all_day_event = "0"
        }
  
        let params = [
            "m_subject"           : cMeetingParamList.m_subject,
            "m_type"              : cMeetingParamList.m_type,
            "r_id"                : cMeetingParamList.r_id!,
            "m_date"              : cMeetingParamList.m_date,
            "m_day"               : cMeetingParamList.m_day,
            "m_start_time"        : cMeetingParamList.m_start_time,
            "m_end_time"          : cMeetingParamList.m_end_time,
            "m_with"              : cMeetingParamList.m_with,
            "m_location"          : cMeetingParamList.m_location,
            "m_all_day_event"     : cMeetingParamList.m_all_day_event,
            "g_id"                : cMeetingParamList.g_id,
            "m_other_user"        : cMeetingParamList.m_other_user,
            "m_invited_by"        : cMeetingParamList.m_invited_by,
            "m_agenda"            : cMeetingParamList.m_agenda ,
            "m_reminder_flag"     : cMeetingParamList.m_reminder_flag,
            "re_id"               : cMeetingParamList.re_id,
            "m_reoccurrence_flag" : cMeetingParamList.m_reoccurrence_flag,
            "m_reoccurrence_type" : cMeetingParamList.m_reoccurrence_type,
            "m_week_day"          : cMeetingParamList.m_week_day,
            "m_week_no"           : cMeetingParamList.m_week_no,
            "m_end_by_date"       : cMeetingParamList.m_end_by_date,
            "m_end_after_days"    : cMeetingParamList.m_end_after_days,
            "l_id"                : cMeetingParamList.l_id,
            "logged_in_user_id"   : strUserId,
            "m_internal_user"     : cMeetingParamList.m_internal_user
            ] as [String : Any]
        
        print("paramsList = \(params)")
        self.bMeetingStatus = false
        let urlStr = "http://kanishkagroups.com/sop/android/insertMeetingMms.php"
     
        Alamofire.request(urlStr, method: .post, parameters: params).responseString{ response in
            print(response)

            switch response.result
            {
               case .success:
              
                let string = response.result.value
                var dictonary:NSDictionary?
                print("String=\(String(describing: string))")
                if let data = string?.data(using: String.Encoding.utf8) {
                    
                    do {
                        dictonary =  try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] as NSDictionary?
                        
                        if let myDictionary = dictonary
                        {
                            print(myDictionary)
                            var msg = ""
                             msg = myDictionary["e"] as! String
                            if msg == ""
                            {
                                let parameteres = ["user_id" : self.strUserId]
                                APIManager().getMeetingDetails(params: parameteres, nGetMeeting: 1)
                                self.bMeetingStatus = true
                                msg = myDictionary["s"] as! String
                                
                            }
                            self.ShowAlertView(sTitile: "Title", cMessage: msg)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }

            case .failure(_):
                print("error")
            }
        }
    }


    func setUpData(DictData : [String: AnyObject])
        {
            self.DictData = DictData
            let modal = ModalController.sharedInstance
           modal.delegate = self as ModalControllerDelegate
            
           if DictData.count != 0
           {
            let roomDict = DictData["rooms"] as! [[String: AnyObject]]
            for lcRoom in roomDict
            {
                let lcrooms = rooms()
                lcrooms.r_Name = lcRoom["r_name"] as! String
                lcrooms.r_id = lcRoom["r_id"] as! String
                self.meetingRoomsArr.append(lcrooms)
            }
            
            let lblDict = DictData["label"] as! [[String: AnyObject]]
            for lclbl in lblDict
            {
                let lclblData = label()
                lclblData.l_name = lclbl["l_name"] as! String
                lclblData.l_id = lclbl["l_id"] as! String
                self.lblBussinessArr.append(lclblData)
            }
            
            let lblReminderDict = DictData["reminder"] as! [[String: AnyObject]]
            for lcreminderDict in lblReminderDict
            {
                let lcreminderData = reminder()
                lcreminderData.re_name = lcreminderDict["re_name"] as! String
                lcreminderData.re_id = lcreminderDict["re_id"] as! String
                lcreminderData.re_selected = false
                self.ReminderArr.append(lcreminderData)
            }
            
            
            let lblGrpDict = DictData["group"] as! [[String: AnyObject]]
            
            for lblgrp in lblGrpDict
            {
                let lcgrpData = group()
                lcgrpData.g_name = lblgrp["g_name"] as! String
                lcgrpData.g_id = lblgrp["g_id"] as! String
                lcgrpData.selected = false
                self.lblGroupArr.append(lcgrpData)
            }
            
            self.userInfoArr.removeAllObjects()
            self.cUserArr.removeAll(keepingCapacity: false)
            let userDict = DictData["user"] as! [[String: AnyObject]]
            for Dict in userDict
            {
                let lcUserData = user()
                let userName = Dict["user_name"] as! String
               
                lcUserData.user_name = Dict["user_name"] as! String
                lcUserData.user_id   = Dict["user_id"] as! String
                
                self.cUserArr.append(lcUserData)
                self.userInfoArr.add(userName)
                }
            self.FilteredForArr = self.userInfoArr as NSArray
            }
        }
  
    @IBAction func OnRoomBtn_Click(_ sender: UIButton)
    {
        self.tagVal = 1
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setRoomsData(cRoomsArr: self.meetingRoomsArr)
        self.view.addSubview(self.cDropDownVc.view)
    }
   
    @IBAction func OnBussinessbtn_Click(_ sender: Any)
    {
        //self.txtSubject.resignFirstResponder()
       // self.txtMeetingLabel.resignFirstResponder()
        self.view.endEditing(true)
        self.tagVal = 2
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setLblData(LblDataArr: self.lblBussinessArr)
        self.view.addSubview(self.cDropDownVc.view)
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onmeetWith_Clikc(_ sender: Any)
    {
        self.tagVal = 4
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setMeetWith()
        self.view.addSubview(self.cDropDownVc.view)
    }
    
    @IBAction func OnMeetType_Click(_ sender: Any)
    {
        self.tagVal = 5
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setMeetType()
        self.view.addSubview(self.cDropDownVc.view)
    }
    
    @IBAction func OnGroup_Click(_ sender: Any)
    {
        if self.lblGroupArr.count == 0
        {
            self.toast.isShow("No groups available")
        }else{
            self.txtGroups.resignFirstResponder()
            self.tagVal = 6
            self.cDropDownVc.view.frame = self.view.bounds
            self.cDropDownVc.delegate = self
            self.cDropDownVc.setGroupArr(cGroupArr: self.lblGroupArr)
            self.view.addSubview(self.cDropDownVc.view)
        }
    }
    
    @IBAction func OnRepeatOnDays_Click(_ sender: Any)
    {
        self.tagVal = 7
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setData(cDayIdArr: DaySelectedId)
        self.view.addSubview(self.cDropDownVc.view)
   }
    
    ////******************** SET A DATE & TIME  *******************//////
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
        
        if textField == txtDate
        {
            createDatePicker()
        }
        else if textField == txtEnddate
        {
            createEndDatePicker()
        }
        
        else if textField == txtDay{
            //createDayPicker()
        }else if textField == txtStartTime{
            createStartTimePicker()
        }else if textField == txtEndTime{
            createEndTimePicker()
        }
    }
    
    func createEndDatePicker()
    {
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(EnddonePresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtEnddate.inputAccessoryView = toolBar
        txtEnddate.inputView = datepicker
    }
    
    @objc func EnddonePresses()
    {
        //format date
        self.AddmeetingScrollView.setContentOffset(CGPoint.zero, animated: true)
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        txtEnddate.text = dateformat.string(from: datepicker.date)
        dateformat.dateFormat = "yyyy-MM-dd"
        self.DateEndStr = self.convertDateFormater(dateformat.string(from: datepicker.date))
        
        cMeetingParamList.m_end_by_date = self.DateEndStr
        print(datepicker.date.dayOfWeek()!)
        self.view.endEditing(true)
    }
    
    func createDatePicker()
    {
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtDate.inputAccessoryView = toolBar
        txtDate.inputView = datepicker
    }
    
    @objc func donePresses()
    {
        //format date
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        txtDate.text = dateformat.string(from: datepicker.date)
        dateformat.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateformat.string(from: datepicker.date))
        self.SelectedDate = datepicker.date
        cMeetingParamList.m_date = self.DateStr
        print(datepicker.date.dayOfWeek()!)
        print(Date().dayNumberOfWeek()!)
        NumDay = datepicker.date.dayNumberOfWeek()
        txtDay.text = datepicker.date.dayOfWeek()
       
        txtRepeatOn.text = txtDay.text
        let DayStr = String(NumDay)
        self.DaySelectedId.removeAll(keepingCapacity: false)
        self.DaySelectedId.append(DayStr)
        cMeetingParamList.m_week_day = self.getArrofJSonString(cidArr: self.DaySelectedId)
        self.view.endEditing(true)
    }

    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    func createStartTimePicker()
    {
        
        datepicker.datePickerMode = .time
        datepicker.minuteInterval = 5
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done,  target: nil, action: #selector(doneBtnPresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtStartTime.inputAccessoryView = toolBar
        txtStartTime.inputView = datepicker
    }

    @objc func doneBtnPresses()
    {
       cMeetingParamList.m_start_time = getHours()
        print(cMeetingParamList.m_start_time)
        
        let dateformat = self.setStartEndTime()
        txtStartTime.text = dateformat.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
 func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
    
    
    func setStartEndTime()->DateFormatter
    {
        let dateformat = DateFormatter()
        dateformat.dateStyle = .none
        dateformat.timeStyle = .short
        return dateformat
    }
    func createEndTimePicker()
    {
        datepicker.datePickerMode = .time
        datepicker.minuteInterval = 5
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DoneBtnPresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtEndTime.inputAccessoryView = toolBar
        txtEndTime.inputView = datepicker
    }

    func getHours()-> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
       return dateFormatter.string(from: datepicker.date)
    }
    
    @objc func DoneBtnPresses()
    {
        //format date
       cMeetingParamList.m_end_time = getHours()
        print(cMeetingParamList.m_end_time)
        let dateformat = self.setStartEndTime()
        txtEndTime.text = dateformat.string(from: datepicker.date)
        self.view.endEditing(true)
    }

    //////****************   END OF DATE & TIME CODE   *************///////
    
   
    
   //**************   PASS STRING    *********************//

    func didSelected(SelectedStr : String, SelectedId : String)
    {
        switch self.tagVal
        {
        case 1:
             self.txtRoom.text = SelectedStr
            self.cMeetingParamList.r_id = SelectedId
        case 2:
            self.txtMeetingLabel.text = SelectedStr
            self.cMeetingParamList.l_id = SelectedId
        case 4:
            self.txtMeetWith.text = SelectedStr
            self.cMeetingParamList.m_with = SelectedId
        case 5:
            self.txtMeetType.text = SelectedStr
            self.cMeetingParamList.m_type = SelectedId
            self.txtRoom.text = ""
            //self.txtRoom.tintColor = UIColor.clear
              if SelectedId == "1"
              {
                self.lblMeetingRoom.text = "Meeting Room"
                btndropdownRooms.isHidden = false
                cMeetingParamList.m_location = "NF"
               
              }else
              {
                self.lblMeetingRoom.text = "Meeting Location"
                btndropdownRooms.isHidden = true
                txtRoom.isUserInteractionEnabled = true
                cMeetingParamList.r_id = "NF"
            }

        default:
            print("Defaults")
        }
    }
    
    @objc private func didtxtRoom()
    {
        
        if lblMeetingRoom.text == "Meeting Room"
        {
             self.view.endEditing(true)
             self.OnRoomBtn_Click(btndropdownRooms)
        }else{
            txtRoom.becomeFirstResponder()
        }
       
    }
    func didSelectedDays(DaysArr: [Days], SelectedId: [String], bDaySelected: Bool)
    {
        
        var dnames = ""
        self.DaySelectedId.removeAll()
        for (index,value) in SelectedId.enumerated()
        {
           self.DaySelectedId = SelectedId
            let nIndex = Int(value)! - 1
            _ = SelectedId[index]
            let lcDaysValue = DaysArr[nIndex]
            let dname = lcDaysValue.Day_Nm
           
            if index == SelectedId.count - 1
            {
                dnames +=  dname!
            }else{
                dnames +=  dname! + ","
            }
            self.txtRepeatOn.text = dnames
        }
        
        if SelectedId.count == 0
        {
            self.txtRepeatOn.text = ""
        }
        
        if self.DaySelectedId.count == 0
        {
            cMeetingParamList.m_week_day = "NF"
        }else{
            cMeetingParamList.m_week_day = self.getArrofJSonString(cidArr: self.DaySelectedId)
        }
    }
    
    func ReminderCheckorNot(bStatus : Bool,SelectedId : [String])
    {
        if tagVal == 6
        {
            var gnames = ""
           var idArr = [String]()
           for (index,value) in SelectedId.enumerated()
           {
             let nIndex = Int(value)
             let lcGroup = self.lblGroupArr[nIndex!]
             let gname = lcGroup.g_name
            
             idArr.append(lcGroup.g_id)
           
             if index == SelectedId.count - 1
                {
                    gnames +=  gname!
                }else{
                    gnames +=  gname! + ","
                 }
            
            self.txtGroups.text = gnames
            }
            
            if SelectedId.count == 0
            {
              self.txtGroups.text = ""
            }
              cMeetingParamList.g_id = self.getArrofJSonString(cidArr: idArr)
        }
        else
        {
            if bStatus
            {
               self.bCheckReminderStatus = true
               self.btnUnCheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
                cMeetingParamList.m_reminder_flag = "1"
            }else{
                self.bCheckReminderStatus = false
                self.btnUnCheckBox.setImage(UIImage(named:"unchecked-checkbox"), for: .normal)
                cMeetingParamList.m_reminder_flag = "0"
            }
         print(SelectedId)
           cMeetingParamList.re_id = self.getArrofJSonString(cidArr: SelectedId)
        }
    }

    func getArrofJSonString(cidArr : [String])->String
    {
        guard let data = try? JSONSerialization.data(withJSONObject: cidArr, options: []) else {
            return "No Found"
        }
        
        let JsonStringArr = String(data: data, encoding: String.Encoding.utf8)!
      
        return JsonStringArr
    }

    @IBAction func AllDayEvent_Click(_ sender: Any)
    {
        bAllDayunchek = !bAllDayunchek
    
        if bAllDayunchek
        {
            AllDayUncheckbtn.setImage(UIImage(named:"checkbox"), for: .normal)
            self.txtStartTime.text           = "9.00 AM"
            self.txtEndTime.text             = "7.00 PM"
            cMeetingParamList.m_start_time   = "09:00:00"
            cMeetingParamList.m_end_time    = "19:00:00"
            cMeetingParamList.m_all_day_event = "1"
            self.txtStartTime.isUserInteractionEnabled = false
            self.txtEndTime.isUserInteractionEnabled    = false
        } else {
            self.txtStartTime.text = ""
            self.txtEndTime.text  = ""
            cMeetingParamList.m_all_day_event = "0"
            self.AllDayUncheckbtn.setImage(UIImage(named:"unchecked-checkbox"), for: .normal)
            self.txtEndTime.isUserInteractionEnabled = true
            self.txtStartTime.isUserInteractionEnabled = true
        }
    }
    
    func ShowAlertView(sTitile: String, cMessage: String)
    {
        let alertController = UIAlertController(title: sTitile, message: cMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
           
            if self.bMeetingStatus
            {
               
                let InterfaceVC = self.storyboard?.instantiateViewController(withIdentifier: "InterfaceBuilderViewController") as!
                InterfaceBuilderViewController
                InterfaceVC.setUserId(cUserId: self.strUserId, cJSON: self.DictData)
        //        InterfaceVC.setUserId(cUserId: self.strUserId,cJSON:self.)
                self.navigationController?.pushViewController(InterfaceVC, animated: true)
                
            }else{
                 print("OK Pressed")
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    ////**************   Submit Alert Action    ******************/////
    @IBAction private func ForwardBtn_Pressed(_ sender: Any)
    {
       formValid = true
        if txtSubject.text == ""
        {
         
            self.toast.isShow("Please enter a subject")
            formValid = false
            return
        }
       
        if txtDate.text == ""
        {
            self.toast.isShow("Please select a date")
            self.formValid = false
            return
        }
        
        let lcCurrentDate = Date()
        
//        let dateformat = DateFormatter()
//        dateformat.dateFormat = "yyyy-MM-dd"
//
//       let lcDateStr = self.convertDateFormater(dateformat.string(from: datepicker.date))
        
        //let SelectedDate: Date! = self.convetStringToDate(dateStr: self.DateStr)
        
        let dateStatus = self.CompareDates(currentDate: lcCurrentDate, previousDate: self.SelectedDate)
        
        if dateStatus
        {
            self.toast.isShow("Can't insert previous date")
            self.formValid = false
            return
        }
        
        if txtRoom.text == ""
        {
            self.toast.isShow("Please selct a room")
            self.formValid = false
            return
        }
        
        if txtStartTime.text == ""
        {
            self.toast.isShow("Please select a start time")
            self.formValid = false
            return
        }
        if txtEndTime.text == ""
        {
            self.toast.isShow("Please select a end time")
            self.formValid = false
            return
        }

       if txtMeetWith.text == ""
        {
            self.toast.isShow("Please select a meeting with field")
            self.formValid = false
            return
        }
        if txtMeetType.text == ""
        {
            self.toast.isShow("Please select a meeting place field")
            self.formValid = false
            return
        }
        if   txtMeetingLabel.text == ""
        {
            self.toast.isShow("Please select meeting type")
            self.formValid = false
            return
        }
        if (txtInternalusers.text == "") && (txtGroups.text == "") && (txtOtherGrp.text == "")
        {
             self.toast.isShow("Please enter at least any one field from Internal User or other user or Groups")
            self.formValid = false
            return
        }
        
        if   txtInvitedBy.text == ""
        {
            self.toast.isShow("Please enter name of Invited by person")
            self.formValid = false
            return
        }
        
        if  (txtOtherGrp.text != "") && (txtOtherGrp.text?.isValidEmail() == false )
        {
            self.toast.isShow("Please enter correct Email ID ar other user")
            self.formValid = false
            return
        }
        
        if txtViewAgenda.text == ""
        {
            self.toast.isShow("Please enter a Agenda")
            return
        }
        
      
        
        if (formValid == true)
        {
            self.ParamList()
        }
    }
    
    ///////////******************   Completed  *************//////////////////
    
    func showBtnView(bStatus: Bool)
    {
        self.viewReoccurance.isHidden = bStatus
        self.btnRadioDaily.isHidden     = bStatus
        self.btnRadioWeekly.isHidden    = bStatus
        self.btnRadoiMonthly.isHidden   = bStatus
        self.lblrdDaily.isHidden        = bStatus
        self.lblRdMontly.isHidden       = bStatus
        self.lblRdweekly.isHidden       = bStatus
    }
    
    @IBAction func ReOccuranceBtn_Click(_ sender: Any)
    {
         bReoccuranceStatus = !bReoccuranceStatus
        
        if bReoccuranceStatus
        {
            cMeetingParamList.m_reoccurrence_flag = "1"
             self.ViewReocHeightConst.constant = 30
            self.showBtnView(bStatus: false)
            self.viewHgtEndDate.constant = 160

       }else
        {
            self.ContentViewHeightConst.constant = 1200
            self.viewHgtEndDate.constant = 120
            cMeetingParamList.m_reoccurrence_flag = "0"
            self.ViewReocHeightConst.constant = 0
            self.showHideControls(bStatus: true)
            btnRadioWeekly.setImage(UIImage(named:"radioUncheck"), for: .normal)
            btnRadoiMonthly.setImage(UIImage(named:"radioUncheck"), for: .normal)
            btnRadioDaily.setImage(UIImage(named:"radioUncheck"), for: .normal)
            btnCheckbox.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            btnCheckBoxReoccur = false
            bCheckweeklyStatus = false
            bCheckMonthStatus   = false
        }
    }
    
    func showHideControls(bStatus : Bool)
    {
        self.btnRadioDaily.isHidden     = bStatus
        self.btnRadioWeekly.isHidden    = bStatus
        self.btnRadoiMonthly.isHidden   = bStatus
        self.lblrdDaily.isHidden        = bStatus
        self.lblRdMontly.isHidden       = bStatus
        self.lblRdweekly.isHidden       = bStatus
        self.lblEndDate.isHidden        = bStatus
        self.txtEnddate.isHidden        = bStatus
        self.lblEndDate.isHidden        = bStatus
        self.txtRepeatOn.isHidden        = bStatus
        self.lblReptOnDay.isHidden        = bStatus
        self.BtnReaptOnDayOutlet.isHidden  = bStatus
    }

    @IBAction func DailyBtn_Click(_ sender: Any)
    {
        self.viewHgtEndDate.constant = 210
        self.BtnReaptOnDayOutlet.isHidden = true
        self.lblEndDate.isHidden = false
        self.txtEnddate.isHidden = false
        self.lblReptOnDay.isHidden = true
        self.txtRepeatOn.isHidden = true
        self.txtEnddate.text = ""
        bCheckweeklyStatus = false
        btnCheckBoxReoccur = !btnCheckBoxReoccur
        bCheckMonthStatus = false
        
         self.ContentViewHeightConst.constant = 1400
       
        cMeetingParamList.m_reoccurrence_type = "1"
        btnRadioWeekly.setImage(UIImage(named:"radioUncheck"), for: .normal)
        btnRadoiMonthly.setImage(UIImage(named:"radioUncheck"), for: .normal)
 
        if btnCheckBoxReoccur {
            cMeetingParamList.m_reoccurrence_flag = "1"
             btnCheckbox.setImage( UIImage(named:"checkbox"), for: .normal)
            btnRadioDaily.setImage( UIImage(named:"radiobutton_selected"), for: .normal)
        }else{
            cMeetingParamList.m_reoccurrence_flag = "0"
            btnCheckbox.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            btnRadioDaily.setImage( UIImage(named:"radioUncheck"), for: .normal)
        }
    }
    
   
    @IBAction func WeeklyBtn_Click(_ sender: Any)
    {
        self.viewHgtEndDate.constant = 273
    
        self.lblEndDate.isHidden = false
        self.lblReptOnDay.isHidden = false
        self.BtnReaptOnDayOutlet.isHidden = false
        self.txtEnddate.isHidden = false
        self.txtRepeatOn.isHidden = false
        self.txtRepeatOn.text = ""
        self.txtEnddate.text = ""
        self.txtRepeatOn.text = self.txtDay.text

        self.lblReptOnDay.setTitle("Repeat On Days", for: .normal)
        
        bCheckweeklyStatus = !bCheckweeklyStatus
        btnCheckBoxReoccur = false
         bCheckMonthStatus = false
        
        cMeetingParamList.m_reoccurrence_type = "2"
  
        btnRadioDaily.setImage( UIImage(named:"radioUncheck"), for: .normal)
        btnRadoiMonthly.setImage(UIImage(named:"radioUncheck"), for: .normal)
        self.ContentViewHeightConst.constant = 1400
      
        if bCheckweeklyStatus {
            cMeetingParamList.m_reoccurrence_flag = "1"
           btnCheckbox.setImage( UIImage(named:"checkbox"), for: .normal)
            btnRadioWeekly.setImage( UIImage(named:"radiobutton_selected"), for: .normal)
        }else{
            cMeetingParamList.m_reoccurrence_flag = "0"
            btnCheckbox.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            btnRadioWeekly.setImage( UIImage(named:"radioUncheck"), for: .normal)
        }
       
        
    }
    
    @objc private func didtxtReaptOn()
    {
        
        if lblReptOnDay.currentTitle == "Repeat On Days"
        {
            self.view.endEditing(true)
            self.OnRepeatOnDays_Click(BtnReaptOnDayOutlet)
        }else{
            txtRepeatOn.becomeFirstResponder()
        }
    }
    @IBAction func MonthlyBtn_Click(_ sender: Any)
    {
         self.viewHgtEndDate.constant = 273
        self.lblEndDate.isHidden = false
        self.lblReptOnDay.isHidden = false
        self.BtnReaptOnDayOutlet.isHidden = true
        self.txtEnddate.isHidden = false
        self.txtRepeatOn.isHidden = false
        self.txtRepeatOn.text = ""
        self.txtEnddate.text = ""
       
        bCheckweeklyStatus = false
        btnCheckBoxReoccur = false
        bCheckMonthStatus = !bCheckMonthStatus
     
        cMeetingParamList.m_reoccurrence_type = "3"
        btnRadioDaily.setImage( UIImage(named:"radioUncheck"), for: .normal)
        btnRadioWeekly.setImage(UIImage(named:"radioUncheck"), for: .normal)
       
        
        self.lblReptOnDay.setTitle("Repeat On Week", for: .normal)

        self.ContentViewHeightConst.constant = 1400
      
         if bCheckMonthStatus {
            cMeetingParamList.m_reoccurrence_flag = "1"
            btnCheckbox.setImage( UIImage(named:"checkbox"), for: .normal)
            btnRadoiMonthly.setImage(UIImage(named:"radiobutton_selected"), for: .normal)
         }else{
            cMeetingParamList.m_reoccurrence_flag = "0"
            btnCheckbox.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            btnRadoiMonthly.setImage( UIImage(named:"radioUncheck"), for: .normal)
            //self.UserIntraction(bStatus: true)
        }
    }
    
    @IBAction func onReminder_Click(_ sender: Any)
    {
        self.tagVal = 3
        self.cDropDownVc.view.frame = self.view.bounds
        self.cDropDownVc.delegate = self
        self.cDropDownVc.setAddmeetingReminder(reminderArr : self.ReminderArr,bCheckReminderStatus: self.bCheckReminderStatus,reid: self.reidArr)
        self.view.addSubview(self.cDropDownVc.view)
    }
    
    @IBAction func onUncheckReminder_Click(_ sender: Any)
    {
       self.bCheckReminderStatus = !self.bCheckReminderStatus
       let cReminder = self.ReminderArr[2]
        if self.bCheckReminderStatus
        {
            self.bCheckReminderStatus = true
            if self.reidArr.count == 0
            {
                self.reidArr.insert(cReminder.re_id, at: 0)
            }
           btnUnCheckBox.setImage( UIImage(named:"checkbox"), for: .normal)
             cMeetingParamList.m_reminder_flag = "1"
        }else
        {
            btnUnCheckBox.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            
            if self.reidArr.count == 1
            {
                self.reidArr.remove(at: 0)
            
            }
            
            if self.reidArr.count > 1
            {
                self.reidArr.removeAll()
            }
            self.bCheckReminderStatus = false
             cMeetingParamList.m_reminder_flag = "0"
            
            for (index , _) in self.ReminderArr.enumerated()
            {
                let cReminder = self.ReminderArr[index]
                cReminder.re_selected = false
             }
        }
        
        cMeetingParamList.re_id = self.getArrofJSonString(cidArr: self.reidArr)
        
}
 
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField){
       activeField = nil
        if textField == txtRoom
        {
            cMeetingParamList.m_location = self.txtRoom.text
            cMeetingParamList.r_id = "NF"
        }
   
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.AddmeetingScrollView.setContentOffset(CGPoint.zero, animated: true)
        self.view.endEditing(true)
        return true
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let lnActualLen = textField.text?.count
        let lnNewlen = string.count
        let finalLen = lnActualLen! + lnNewlen - range.length
       // print(finalLen)
        self.tblView.isHidden = false
        
        if finalLen == 0
        {
            self.tblView.isHidden = true
        }
        
        if txtInternalusers.text == ""
        {
            self.name = ""
        }
        
        if textField.text == ""
        {
            result = ""
        }
        if textField == txtInternalusers
        {
            
            if string != ","
            {
                result = result + string
               // print(result)
            }
            
            if string == ""
            {
                result = ""
                
            }
            
            self.tblTopConstraint.constant = 5
            if result.count > 1
            {
                self.FetchResult(nFinalLen: finalLen)
            }
            bStausField = false
            
        }else if textField == txtInvitedBy
        {
            result = result + string
           
            self.tblTopConstraint.constant = 135
            if result.count > 1
            {
              self.FetchResult(nFinalLen: finalLen)
            }
            
            bStausField = true
        }
        
        return true
    }
    
    func FetchResult(nFinalLen : Int)
    {
        
        let predicate = NSPredicate(format: "SELF CONTAINS[c]  %@", result)
        
        self.FilteredArr  = FilteredForArr.filtered(using: predicate) as NSArray
        
       // print("names = \(FilteredArr)")
        if(nFinalLen == 0){
            result = ""
            self.tblViewHeightConst.constant = 0
        } else {
            self.tblViewHeightConst.constant = 188
        }
        self.tblView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return self.FilteredArr.count
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
    
           let name = self.FilteredArr[indexPath.row] as! String
            cell.setData(cuserName: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 46.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
        bSelected = true
        self.result = ""
        
        if bStausField
        {
            self.txtInvitedBy.text = self.FilteredArr[indexPath.row] as? String
       
            for (_,lcUser) in self.cUserArr.enumerated()
            {
                if lcUser.user_name == self.txtInvitedBy.text
                {
                    cMeetingParamList.m_invited_by = lcUser.user_id
                }
            }
            
        }else{
            let stringName = self.FilteredArr[indexPath.row] as! String
            
            name +=  stringName + ","
            
            self.txtInternalusers.text = name
            

  
            for (_,lcUser) in self.cUserArr.enumerated()
            {
                if lcUser.user_name == stringName
                {
                    lcUserArr.append(lcUser.user_id)
                    //print(cMeetingParamList.m_internal_user)
                }
            }

            cMeetingParamList.m_internal_user = self.getArrofJSonString(cidArr: lcUserArr)
        }
        
       self.tblViewHeightConst.constant = 0
    }
    /*
    func didEventSelected(_ event: SSEvent!)
    {

        print("Event : \(event.name, event.desc)")

        let lcRescduleMeetingVC = storyboard?.instantiateViewController(withIdentifier: "RescduleMeetingVC") as! RescduleMeetingVC
        lcRescduleMeetingVC.m_id = event.mid
        lcRescduleMeetingVC.setUpData(DictData: self.DictData)
        self.navigationController?.pushViewController(lcRescduleMeetingVC, animated: true)
    }
    */
    func convetStringToDate(dateStr: String)->Date!
    {
        print("DateStr= ",dateStr)
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        let date: Date! = dateFormate.date(from: dateStr)
        print("date= ",date)
        return date
    }
    
    func CompareDates(currentDate: Date, previousDate: Date) -> Bool
    {
        
        if previousDate < currentDate
        {
            return true
        }
        
        return false
    }
    
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

enum WeekDays: String
{
    case Sunday
    case Monday
    case Tuesday
    case Wensday
    case Thursday
    case Friday
    case Saturday
}


