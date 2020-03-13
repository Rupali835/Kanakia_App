//
//  RescduleMeetingVC.swift
//  Kanakia SOP
//  Created by user on 17/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


@objc class RescduleMeetingVC: UIViewController, UITextFieldDelegate,UITextViewDelegate,SelectedStringDelegate, UITableViewDataSource, UITableViewDelegate,ModalControllerDelegate, UIGestureRecognizerDelegate
{
    func didSelectedDays(DaysArr: [Days], SelectedId: [String], bDaySelected: Bool)
    {
        
    }
   
    @IBOutlet weak var btnAllDayOutlet: UIButton!
    @IBOutlet weak var ArrGroups: MKButton!
    @IBOutlet weak var ArrMeetType: MKButton!
    @IBOutlet weak var ArrMeetWith: MKButton!
    @IBOutlet weak var ArrBusinessType: MKButton!
    @IBOutlet weak var scrollReshedule: SPKeyBoardAvoiding!
    @IBOutlet weak var BtnRoomDropDown: MKButton!
    @IBOutlet weak var OneBtnView: UIView!
    @IBOutlet weak var TwoBtnView: UIView!
    @IBOutlet weak var StartLeadConst: NSLayoutConstraint!
    @IBOutlet weak var StartTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var ResheduleLeadConst: NSLayoutConstraint!
    @IBOutlet weak var checkAllDayEvent: UIButton!
    @IBOutlet weak var BtnReshedule: UIButton!
    @IBOutlet weak var ContentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var BtnDelete: UIButton!
    @IBOutlet weak var BtnStart: UIButton!
    @IBOutlet weak var BtnsView: UIView!
    @IBOutlet weak var R_ContentView: UIView!
    @IBOutlet weak var R_mainView: UIView!
    @IBOutlet weak var R_subject: MKTextField!
    @IBOutlet weak var R_day: MKTextField!
    @IBOutlet weak var R_Date: MKTextField!
    @IBOutlet weak var R_StartTime: MKTextField!
    @IBOutlet weak var R_EndTime: MKTextField!
    @IBOutlet weak var R_AllDayEvent: UILabel!
    @IBOutlet weak var R_Lbl_MeetWith: UILabel!
    @IBOutlet weak var R_txtRoom: MKTextField!
    @IBOutlet weak var R_InternalUser: MKTextField!
    @IBOutlet weak var R_Groups: MKTextField!
    @IBOutlet weak var R_MeetPlace: UILabel!
    @IBOutlet weak var R_TblView: UITableView!
    @IBOutlet weak var R_TpLbl: UILabel!
    @IBOutlet weak var R_ForwardBtn: UIButton!
    @IBOutlet weak var R_TypeLbl: UILabel!
    @IBOutlet weak var R_Reminder: MKButton!
    @IBOutlet weak var R_BtnReminderForChek: UIButton!
    @IBOutlet weak var R_invitedBy: MKTextField!
    @IBOutlet weak var R_agenda: UITextView!
    @IBOutlet weak var R_OtherUser: MKTextField!
    @IBOutlet weak var btnUnCheckBox: UIButton!
    @IBOutlet weak var tblTopConst: NSLayoutConstraint!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMoveBtn: UILabel!
    
    @IBOutlet weak var btnend: MKButton!
    private var toast: JYToast!
    var Selected_m_id : String!
    var selectedM_id : String?
    var momStatus : String?
    var DateStr : String!
    var lcRid : String!
    var Meetingdata: [AnyObject]? = [AnyObject]()
    var SelectedRoomStr : String!
    var activeField        : UITextField?
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var NumDay : Int!
    var m_id: String!
    var m_Status: String!
    var m_cMeetingStatus: Int!
     var bAllDayunchek = Bool(false)
    var m_Occupied: String!
    
    var singleMeeting = [AnyObject]()
    var tagVal = Int(0)
    var cDropDownVC : DropDownVC!
    var lblBussinessArr = [label]()
    var meetingRoomsArr = [rooms]()
    var ReminderArr = [reminder]()
    var lblDaysArr  = [Days]()
    var lblGroupArr = [group]()
    var bSelected = Bool(false)
    var userInfoArr = NSMutableArray()
    var FilteredArr = NSArray()
    var FilteredForArr = NSArray()
    var SelectedArr = NSMutableArray()
    var bStausField: Bool!
    var JsonArr : String!
    var jsoninterUserArr: String!
    var lcUserArr = [String]()
    var reidArr = [String]()
    var bCheckReminderStatus = Bool(false)
    var cUserArr = [user]()
    var txtValid : Bool = false
    var StatusNum : String!
    var InternalUserIdArr = [String]()
    var groupArr = [String]()
    var NameArr = [String]()
    var groupNameArr = [String]()
    var Re_MeetingParam = ResheduleParamList()
    var result: String = ""
    var name: String = ""
    var idArr = [String]()
 //   var bSelected = Bool(false)
    var BAllDayunchek = Bool(false)
//    var bCheckReminderStatus = Bool(false)
    var bCheckweeklyStatus = Bool(false)
    var bCheckMonthStatus = Bool(false)
//     var lcUserArr = [String]()
    var preIndex = Int(-1)
    var l_id: String!
     var formValid = Bool(true)
    var bMeetingStatus = Bool(false)
    var cMomVc : MomVc!
    var cFileDocumentVc : FileDocumentVc!
    
    override func awakeFromNib()
    {
        self.cDropDownVC = self.storyboard?.instantiateViewController(withIdentifier: "DropDownVC") as! DropDownVC
        
        self.cMomVc = storyboard?.instantiateViewController(withIdentifier: "MomVc") as! MomVc
        
        self.cFileDocumentVc = storyboard?.instantiateViewController(withIdentifier: "FileDocumentVc") as! FileDocumentVc
        
    }
    var strUserId : String = ""      // userdefault declareation

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.ContentViewHeightConstraint.constant = 950
        self.UserIntractiontoControl(bStatus: false)
        self.DesignTextfield(txtField: R_subject)
        self.DesignTextfield(txtField: R_Date)
        self.DesignTextfield(txtField: R_day)
        self.DesignTextfield(txtField: R_StartTime)
        self.DesignTextfield(txtField: R_EndTime)
        self.DesignTextfield(txtField: R_Groups)
        self.DesignTextfield(txtField: R_txtRoom)
        self.DesignTextfield(txtField: R_InternalUser)
        self.DesignTextfield(txtField: R_OtherUser)
        self.DesignTextfield(txtField: R_InternalUser)
        self.DesignTextfield(txtField: R_invitedBy)
   //     self.R_txtRoom.text = self.SelectedRoomStr
        self.R_agenda.delegate = self
        self.R_Date.delegate        = self
        self.R_day.delegate         = self
        self.R_StartTime.delegate   = self
        self.R_EndTime.delegate     = self
     
        self.R_TblView.delegate       = self
        self.R_TblView.dataSource     = self
        R_InternalUser.delegate = self
        
        R_mainView.layer.shadowOpacity = 1.0
        R_mainView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        R_mainView.layer.shadowRadius  = 15.0
        R_mainView.layer.shadowColor   = UIColor.white.cgColor
        R_mainView.layer.cornerRadius  = 4
        R_mainView.layer.masksToBounds = false
        R_mainView.layer.borderWidth = 1.0
        
        self.tblHeightConstraint.constant  = 0
        self.fetchSingleMeeting()
        
        self.R_TypeLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didlblTapHeader)))
        self.R_Lbl_MeetWith.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtMeetWith)))
        self.R_MeetPlace.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtMeetType)))
        self.R_Groups.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtGroup)))
        self.R_txtRoom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didtxtRoom)))
        
        
        if m_cMeetingStatus == 0
        {
            self.BtnsView.isHidden = true
            self.OneBtnView.alpha = 1.0
            self.btnend.setTitle("DECLINE", for: .normal)
            self.BtnsView.backgroundColor = UIColor.red
            
        }else
        {
            self.BtnsView.isHidden = false
            self.OneBtnView.alpha = 0.0
        }
        
        if m_Occupied == "1", m_cMeetingStatus == 1
        {
            self.BtnsView.isHidden = true
            self.TwoBtnView.alpha = 0.0
            self.OneBtnView.alpha = 1.0
        }
        if m_Occupied == "2", m_cMeetingStatus == 1
        {
            self.BtnsView.isHidden = true
            self.TwoBtnView.alpha = 0.0
            self.OneBtnView.alpha = 0.0
        }
        initUi()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.R_ContentView))!
        {
            self.view.endEditing(true)
            return false
        }
        return true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    @objc private func didtxtGroup()
    {
        self.view.endEditing(true)
        self.R_Groups_Click(ArrGroups)
    }
    @objc private func didtxtMeetType()
    {
        self.view.endEditing(true)
        self.R_MeetPlace_Clcik(ArrMeetType)
    }
    @objc private func didtxtMeetWith()
    {
        self.view.endEditing(true)
        self.R_MeetWith_Click(ArrMeetWith)
    }
    @objc private func didlblTapHeader()
    {
        self.view.endEditing(true)
        self.R_Type_Click(ArrBusinessType)
    }
    @objc private func didtxtRoom()
    {
        
        if R_txtRoom.placeholder == "Room"
        {
            self.view.endEditing(true)
            self.OnRoomBtn_Click(BtnRoomDropDown)
        }else{
            R_txtRoom.becomeFirstResponder()
        }
        
    }
    
    func MeetingDetails(Details: [AnyObject])
    {
        self.Meetingdata = Details
    }
    
    func fetchSingleMeeting()
    {
        //fetching data from userdefaults
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        
        strUserId = userDict["user_id"] as! String
        
        
        let parameteres = [ "m_id": self.m_id!] as [String: Any]
        print(parameteres)
        let UrlStr  = "http://www.kanishkagroups.com/sop/android/getSingleMeetingMms.php"
        
        Alamofire.request(UrlStr, method: .post, parameters: parameteres).responseJSON { (resp) in
        
            switch resp.result
            {
            case .success(_):
                self.singleMeeting = (resp.result.value as? [AnyObject])!
                print("Result \(self.singleMeeting)")
                //self.tblMeeting.reloadData()
                for (index,_) in self.singleMeeting.enumerated()
                {
                    self.setupData(nIndex: index)
                }
                break
            
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
    }

    func StartMeeting()
    {
        let pramtr : [String: String] =
        [
            "user_id" : strUserId,
            "m_id" : self.m_id!,
            "status" : self.StatusNum!
        ]
        
         let url = "http://www.kanishkagroups.com/sop/android/updateMeetingStatusMrms.php"
        Alamofire.request(url, method: .post, parameters: pramtr, encoding: URLEncoding.default)
            .responseJSON { response in
                print(response)
                self.toast.isShow("Meeting Ended Successfully")
        }
    
    }
    
    func ApiForReshedule()
    {
        Re_MeetingParam.m_subject_edit = R_subject.text
        Re_MeetingParam.m_day_edit = R_day.text
        Re_MeetingParam.m_start_time_edit = R_StartTime.text
        Re_MeetingParam.m_end_time_edit = R_EndTime.text
  
        Re_MeetingParam.m_agenda_edit = R_agenda.text
        Re_MeetingParam.m_other_user_edit = R_OtherUser.text

      
        if (R_InternalUser.text?.isEmpty)!
        {
            Re_MeetingParam.m_internal_user = "NF"
        }
        if (R_OtherUser.text?.isEmpty)!
        {
            Re_MeetingParam.m_other_user_edit = "NF"
        }
        
        if (R_Groups.text?.isEmpty)!
        {
            Re_MeetingParam.g_id_edit = "NF"
        }
    
        if Re_MeetingParam.m_reminder_flag_edit == "0"
        {
            Re_MeetingParam.m_reminder_flag_edit = "NF"
        }
       
        let parms : [String: String] =
            [
                "m_subject_edit"    : Re_MeetingParam.m_subject_edit,
                "m_type_edit"       : Re_MeetingParam.m_type_edit,
                "r_id_edit"         : Re_MeetingParam.r_id_edit,
                "m_date_edit"       : Re_MeetingParam.m_date_edit,
                "m_day_edit"        : Re_MeetingParam.m_day_edit,
                "m_start_time_edit" : Re_MeetingParam.m_start_time_edit,
                "m_end_time_edit"   : Re_MeetingParam.m_end_time_edit,
                "m_with_edit"       : Re_MeetingParam.m_with_edit,
                "m_location_edit"   : Re_MeetingParam.m_location_edit,
                "m_all_day_event_edit" : Re_MeetingParam.m_all_day_event_edit,
                "g_id_edit"         : Re_MeetingParam.g_id_edit,
                "m_other_user_edit" : Re_MeetingParam.m_other_user_edit ,
                "m_invited_by_edit" : Re_MeetingParam.m_invited_by_edit,
                "m_agenda_edit"     : Re_MeetingParam.m_agenda_edit,
                "m_reminder_flag_edit" : Re_MeetingParam.m_reminder_flag_edit,
                "re_id_edit"        : Re_MeetingParam.re_id_edit,
                "l_id_edit"         : Re_MeetingParam.l_id_edit,
                "logged_in_user_id" : strUserId,
                "edit_m_id"         : Re_MeetingParam.edit_m_id,
                "m_internal_user"   : Re_MeetingParam.m_internal_user
           ]
        
        print("Reshedule parametre : \(parms)")
        self.bMeetingStatus = false
        let ResheduleUrl = "http://www.kanishkagroups.com/sop/android/editMeetMms.php"
        
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        
        Alamofire.request(ResheduleUrl, method: .post, parameters: parms).responseJSON { (Resp) in
            print(Resp)
            
            OperationQueue.main.addOperation {
                SVProgressHUD.dismiss()
            }
            
            switch Resp.result
            {
            case .success:
                if let result = Resp.result.value
                {
                    let responseDict = result as! [String : Any]
                    
                    var msg = ""
                    msg = responseDict["e_m"] as! String
                    
                    if msg == ""
                    {
                        let parameteres = ["user_id" : self.strUserId]
                        APIManager().getMeetingDetails(params: parameteres, nGetMeeting: 1)
                        self.bMeetingStatus = true
                        msg = responseDict["s_m"] as! String
                    }
                    self.ShowAlert(sTitile: "Title", cMessage: msg)
                    
                }
                
            case .failure(let error):
                self.toast.isShow("Something went wrong")
                print(error)
            }

        }
    }
    
    
    func CancleMeeting()
    {
      let pr : [String: String] = ["m_id" : self.m_id]
      let strUrl = "http://www.kanishkagroups.com/sop/android/deleteMeetMrms.php"
        Alamofire.request(strUrl, method: .post, parameters: pr).responseJSON { (Resp) in
            print(Resp)
            
            switch Resp.result
            {
            case .success(_):
                let json = Resp.result.value as! NSDictionary
                let msg = json["msg"] as! String
                self.toast.isShow(msg)
                self.navigationController?.popViewController(animated: true)
                break
            
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
           

        }
    }
    
    func dayOfWeek(cDate : Date) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: cDate).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func getDateFromString(cDateStr : String)-> Date
    {
       
        let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "YYYY-MM-dd"
        let date  = dateFormatter.date(from: cDateStr)!
        return date
        
        
    }
    
    func GetConcatString(cNameArr: [String]) ->String
    {
      var Unames = ""
        for(index, _) in cNameArr.enumerated()
        {
            let lcname = cNameArr[index]
            
            if index == cNameArr.count - 1
            {
                Unames += lcname
            }else{
                Unames = lcname + ","
            }
            
        }
        return Unames
    }
    
    func GetLabelTextandId(l_id: String)
    {
        if l_id == "1"
        {
         self.R_TypeLbl.text = "Business"
          Re_MeetingParam.l_id_edit = "1"
        }else{
                self.R_TypeLbl.text = "Personal"
              Re_MeetingParam.l_id_edit = "2"
        }
    }
    
    func getMeetWith(mWithId: String)
    {
        if mWithId == "1"
        {
            Re_MeetingParam.m_with_edit = "1"
            self.R_Lbl_MeetWith.text = "Internal Person"
        }
        else
        {
            Re_MeetingParam.m_with_edit = "2"
            self.R_Lbl_MeetWith.text = "External Person"
        }
    }
    
    func getMeetType(mTypeId: String)
    {
        if mTypeId == "1"
        {
            self.view.endEditing(true)
            Re_MeetingParam.m_type_edit = "1"
            self.R_MeetPlace.text = "HO"
            self.R_txtRoom.attributedPlaceholder = NSAttributedString(string:"Room", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font :UIFont(name: "Arial", size: 16)!])
            BtnRoomDropDown.isHidden = false
            self.R_txtRoom.text = self.SelectedRoomStr
            Re_MeetingParam.r_id_edit = lcRid
            Re_MeetingParam.m_location_edit = "NF"
        }
        else
        {
            Re_MeetingParam.m_type_edit = "2"
            self.R_MeetPlace.text = "External"
            self.R_txtRoom.attributedPlaceholder = NSAttributedString(string:"Location", attributes:[NSAttributedStringKey.foregroundColor: UIColor.gray,NSAttributedStringKey.font :UIFont(name: "Arial", size: 16)!])
            BtnRoomDropDown.isHidden = true
            Re_MeetingParam.m_location_edit = ""
            Re_MeetingParam.r_id_edit = "NF"
            
        }
    }
    
    func GetGroupId(ngidArr: [String])
    {
        self.idArr.removeAll()
        for (index,_) in ngidArr.enumerated()
        {
            let lcGroupid = ngidArr[index]
            self.idArr.append(lcGroupid)
        }
         Re_MeetingParam.g_id_edit = self.getArrofJSonString(cidArr: self.idArr)
    }
    
    func GetRoomType()
    {
        
    }
    
    func GetInternalUsersId(nUserId: [String])
    {
        self.idArr.removeAll()
        for (index,_) in nUserId.enumerated()
        {
            let lcAlluser = self.cUserArr[index]
            self.idArr.append(lcAlluser.user_id)
        }
        
        Re_MeetingParam.m_internal_user = self.getArrofJSonString(cidArr: self.idArr)
    }
    

    func GetReminderId(nReminderId: [String])
    {
        self.idArr.removeAll()
       
        for (_,value) in nReminderId.enumerated()
        {
            if value != "No Found"
            {
                let nIndex = Int(value)
                for lcReminder in self.ReminderArr
                {
                    if Int(lcReminder.re_id) == nIndex
                    {
                        self.idArr.append(lcReminder.re_id)
                    }
                }
                
                
            }
        
        }
        
        Re_MeetingParam.re_id_edit = self.getArrofJSonString(cidArr: self.idArr)
    }
    
    
    func setupData(nIndex: Int)
    {
        self.momStatus = self.singleMeeting[nIndex]["mom_status"] as? String
        
        self.selectedM_id = self.singleMeeting[nIndex]["m_id"] as? String
        self.R_subject.text = self.singleMeeting[nIndex]["m_subject"] as? String
        self.R_Date.text = self.singleMeeting[nIndex]["m_date"] as? String
        
        if let cDate = self.singleMeeting[nIndex]["m_date"] as? String
        {
        
          let lbldate =  getDateFromString(cDateStr: cDate)
            
         self.R_day.text = dayOfWeek(cDate: lbldate)
  
            
        }
        
        Re_MeetingParam.m_date_edit = R_Date.text
        
        if let l_id = self.singleMeeting[nIndex]["l_id"] as? String
        {
            self.GetLabelTextandId(l_id: l_id)
        }
        
        self.R_StartTime.text = self.singleMeeting[nIndex]["m_start_time"] as? String
        self.R_EndTime.text = self.singleMeeting[nIndex]["m_end_time"] as? String
        self.R_OtherUser.text = self.singleMeeting[nIndex]["m_other_user"] as? String
        
        
        if let mid = self.singleMeeting[nIndex]["m_id"] as? String
        {
            Re_MeetingParam.edit_m_id = mid
        }
        
        
        if let gid = self.singleMeeting[nIndex]["g_id"] as? String
        {
            let g_idArr = self.getArrayFromJSonString(cJsonStr: gid) as [String]
            self.GetGroupId(ngidArr: g_idArr)
            for lcgId in g_idArr
            {
                if let index = self.lblGroupArr.index(where: {$0.g_id == lcgId})
                {
                    let lcAlluser = self.lblGroupArr[index]
                    self.groupNameArr.append(lcAlluser.g_name)
                }
            }
        }
        
        if let meetWith = self.singleMeeting[nIndex]["m_with"] as? String
        {
            self.getMeetWith(mWithId: meetWith)
        }
        
        
        self.R_Groups.text = self.GetConcatString(cNameArr: self.groupNameArr)
        
        
        let render = self.singleMeeting[nIndex]["m_agenda"] as? String
        
        
        let str = render?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        
        let Str = str?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        let str1 = Str?.replacingOccurrences(of: "\n", with: "\n", options: .regularExpression, range: nil)

        self.R_agenda.text = str1
        
        
        let M_type = self.singleMeeting[nIndex]["m_type"] as? String
        
        if let m_ntype = M_type
        {
            self.getMeetType(mTypeId: m_ntype)
        }
        
        
        let lcInternalUser = self.singleMeeting[nIndex]["m_internal_user"] as? String
        
        if lcInternalUser == "NF"
        {
            self.R_InternalUser.text = lcInternalUser
            Re_MeetingParam.m_internal_user = lcInternalUser
        }else{
            if let cInternal = lcInternalUser
            {
                self.NameArr.removeAll()
                
                self.InternalUserIdArr = getArrayFromJSonString(cJsonStr: cInternal)
                
                self.GetInternalUsersId(nUserId: self.InternalUserIdArr)
                
                for lcUserId in self.InternalUserIdArr
                {
                    if let index = self.cUserArr.index(where: {$0.user_id == lcUserId})
                    {
                        let lcAlluser = self.cUserArr[index]
                        self.NameArr.append(lcAlluser.user_name)
                    }
                }
                
                 self.R_InternalUser.text = self.GetConcatString(cNameArr: self.NameArr)
        }
        
            
           
            
        }
        
        let lcInvitedByUser = self.singleMeeting[nIndex]["m_invited_by"] as? String
        
        if let cinvitedByUser = lcInvitedByUser
        {
            
            Re_MeetingParam.m_invited_by_edit = cinvitedByUser
            self.NameArr.removeAll()
            
            
            if let index = self.cUserArr.index(where: {$0.user_id == cinvitedByUser})
            {
                let lcAlluser = self.cUserArr[index]
                self.NameArr.append(lcAlluser.user_name)
            }
            
            self.R_invitedBy.text = self.GetConcatString(cNameArr: self.NameArr)
            
        }
        
        self.lcRid = self.singleMeeting[nIndex]["r_id"] as? String
        
        Re_MeetingParam.r_id_edit = lcRid
        
        if let cRid = lcRid
        {
            self.NameArr.removeAll()
            
            if let index = self.meetingRoomsArr.index(where: {$0.r_id == cRid})
            {
                let lcAlluser = self.meetingRoomsArr[index]
                self.NameArr.append(lcAlluser.r_Name)
            }
            
            self.R_txtRoom.text = self.GetConcatString(cNameArr: self.NameArr)
            //self.R_txtRoom.isUserInteractionEnabled = false
        }
        
        if lcRid == "0"
        {
            self.R_txtRoom.text = self.singleMeeting[nIndex]["m_location"] as? String
            //self.R_txtRoom.isUserInteractionEnabled = true
        }
        let bCheckStatus = self.singleMeeting[nIndex]["m_reminder_flag"] as? String
        
        if bCheckStatus == "0"
        {
            self.SetCheckBox(bStatus: false)
        }else{
            self.SetCheckBox(bStatus: true)
        }
        
        let lcReminderId = self.singleMeeting[nIndex]["re_id"] as? String
        
        if let cReminder = lcReminderId
        {
            if cReminder != "Not Provided"
            {
                let lcARR = self.getArrayFromJSonString(cJsonStr: cReminder)
                print(lcARR)
                
                self.GetReminderId(nReminderId: self.getArrayFromJSonString(cJsonStr: cReminder) as [String])
            }else
            {
                Re_MeetingParam.re_id_edit = "Not Provided"
            }
        }
        
        
        let lcAllDayEventId = self.singleMeeting[nIndex]["m_all_day_event"] as? String
        
        if lcAllDayEventId == "1"
        {
            self.R_StartTime.text = "9:00.00 AM"
            self.R_EndTime.text = "19:00:00 PM"
            self.checkAllDayEvent.setImage(UIImage(named: "checkbox"), for: .normal)
            Re_MeetingParam.m_all_day_event_edit = "1"
            
        }else{
            self.checkAllDayEvent.setImage(UIImage(named:"unchecked-checkbox"), for: .normal)
            Re_MeetingParam.m_all_day_event_edit = "0"
        }
        
    }
    
    func SetCheckBox(bStatus: Bool)
    {
        if bStatus{
            self.bCheckReminderStatus = true
            self.btnUnCheckBox.setImage(UIImage(named: "checkbox"), for: .normal)
            
        }else{
            self.bCheckReminderStatus = false
            self.btnUnCheckBox.setImage(UIImage(named:"unchecked-checkbox"), for: .normal)
        }
    }


    
    
    func DesignTextfield(txtField : MKTextField)
    {
        
        txtField.delegate         = self
        txtField.layer.borderColor             = UIColor.clear.cgColor
        txtField.floatingLabelBottomMargin     = 4
        txtField.floatingPlaceholderEnabled    = true
        txtField.bottomBorderWidth             = 1
        txtField.bottomBorderEnabled           = true
        txtField.tintColor = UIColor.blue
        txtField.minimumFontSize = 20.0
    }

    func UserIntractiontoControl(bStatus: Bool)
    {
        self.R_subject.isUserInteractionEnabled     = bStatus
        self.R_TypeLbl.isUserInteractionEnabled     = bStatus
        self.R_Date.isUserInteractionEnabled        = bStatus
        self.R_day.isUserInteractionEnabled         = bStatus
        self.R_StartTime.isUserInteractionEnabled   = bStatus
        self.R_EndTime.isUserInteractionEnabled     = bStatus
        self.R_AllDayEvent.isUserInteractionEnabled = bStatus
        self.R_Lbl_MeetWith.isUserInteractionEnabled = bStatus
        self.R_MeetPlace.isUserInteractionEnabled    = bStatus
        //self.R_txtRoom.isUserInteractionEnabled      = bStatus
        self.R_Groups.isUserInteractionEnabled       = bStatus
        self.R_InternalUser.isUserInteractionEnabled = bStatus
        self.R_OtherUser.isUserInteractionEnabled    = bStatus
        self.R_invitedBy.isUserInteractionEnabled    = bStatus
        self.R_agenda.isUserInteractionEnabled       = bStatus
        self.R_Reminder.isUserInteractionEnabled     = bStatus
        
    }
    
    @IBAction func R_Type_Click(_ sender: Any)
    {
        self.tagVal = 2
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        self.cDropDownVC.setLblData(LblDataArr: self.lblBussinessArr)
        self.view.addSubview(self.cDropDownVC.view)
    }
    
    @IBAction func R_MeetWith_Click(_ sender: Any)
    {
        self.tagVal = 4
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        self.cDropDownVC.setMeetWith()
        self.view.addSubview(self.cDropDownVC.view)
    }
    
    @IBAction func R_MeetPlace_Clcik(_ sender: Any)
    {
        self.tagVal = 5
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        self.cDropDownVC.setMeetType()
        self.view.addSubview(self.cDropDownVC.view)
    }
    
    @IBAction func R_Room_Click(_ sender: Any)
    {
        self.tagVal = 1
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        self.cDropDownVC.setRoomsData(cRoomsArr: self.meetingRoomsArr)
        self.view.addSubview(self.cDropDownVC.view)
    }
    
    
    @IBAction func R_Groups_Click(_ sender: Any)
    {
        if lblGroupArr.count == 0
        {
            self.toast.isShow("No groups available")
        }else{
            self.tagVal = 6
            self.cDropDownVC.view.frame = self.view.bounds
            self.cDropDownVC.delegate = self
            self.cDropDownVC.setGroupArr(cGroupArr: self.lblGroupArr)
            self.view.addSubview(self.cDropDownVC.view)
        }
       
    }
    
    @IBAction func R_OnRemonder_Click(_ sender: Any)
    {
        self.tagVal = 3
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        
        let lcSelectedArr = self.getArrayFromJSonString(cJsonStr: Re_MeetingParam.re_id_edit)
    
        self.cDropDownVC.setReminder(reminderArr : self.ReminderArr,bCheckReminderStatus: self.bCheckReminderStatus,SelectedIdArr: lcSelectedArr)
       
        self.view.addSubview(self.cDropDownVC.view)
        
    }
    
    
    @IBAction func R_BtnReminder_Click(_ sender: Any)
    {
        self.bCheckReminderStatus = !self.bCheckReminderStatus
        
        for lcReminder in self.ReminderArr
        {
            if lcReminder.re_name == "30 Minutes"
            {
                if self.bCheckReminderStatus
                {
                    self.bCheckReminderStatus = true
                    if self.reidArr.count == 0
                    {
                        self.reidArr.insert(lcReminder.re_id, at: 0)
                        
                    }
                    btnUnCheckBox.setImage( UIImage(named:"checkbox"), for: .normal)
                    Re_MeetingParam.m_reminder_flag_edit = "1"
                }else{
                    
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
                    Re_MeetingParam.m_reminder_flag_edit = "0"
                    
                    for (index , _) in self.ReminderArr.enumerated()
                    {
                        
                        let cReminder = self.ReminderArr[index]
                        cReminder.re_selected = false
                        //self.re_idArr.removeAll()
                    }
                }
            }
        }
        //let cReminder = self.ReminderArr[3]
        
        
        
          Re_MeetingParam.re_id_edit = self.getArrofJSonString(cidArr: self.reidArr)
        
        print(self.reidArr)
        
     
    }
    
    @IBAction func R_OnForwardBtn_Click(_ sender: Any)
    {
        
    }
   
    

    
    ////******************** SET A DATE & TIME  *******************//////
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
        
        if textField == R_Date
        {
            createDatePicker()
        }
     
        else if textField == R_day
        {
            //createDayPicker()
        }else if textField == R_StartTime
        {
            createStartTimePicker()
        }else if textField == R_EndTime
        {
            createEndTimePicker()
        }
    }
    
  
    func createDatePicker()
    {
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        toolBar.setItems([barBtnItem], animated: false)
        R_Date.inputAccessoryView = toolBar
        R_Date.inputView = datepicker
    }
    
    @objc func donePresses()
    {
        //format date
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        R_Date.text = dateformat.string(from: datepicker.date)
        dateformat.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateformat.string(from: datepicker.date))
        Re_MeetingParam.m_date_edit = self.DateStr
        print(datepicker.date.dayOfWeek()!)
        print(Date().dayNumberOfWeek()!)
        NumDay = datepicker.date.dayNumberOfWeek()
        R_day.text = datepicker.date.dayOfWeek()
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
        R_StartTime.inputAccessoryView = toolBar
        R_StartTime.inputView = datepicker
    }
    
    @objc func doneBtnPresses()
    {
       // cMeetingParamList.m_start_time = getHours()
       // print(cMeetingParamList.m_start_time)
        
        let dateformat = self.setStartEndTime()
        R_StartTime.text = dateformat.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss" // Output Format
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
        R_EndTime.inputAccessoryView = toolBar
        R_EndTime.inputView = datepicker
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
       // cMeetingParamList.m_end_time = getHours()
       // print(cMeetingParamList.m_end_time)
        let dateformat = self.setStartEndTime()
        R_EndTime.text = dateformat.string(from: datepicker.date)
        self.view.endEditing(true)
    }
    
    //////****************   END OF DATE & TIME CODE   *************///////
      

    func setUpData(DictData : [String: AnyObject])
    {
       
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
            
            self.ReminderArr.removeAll(keepingCapacity: false)
            
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
        self.cDropDownVC.view.frame = self.view.bounds
        self.cDropDownVC.delegate = self
        self.cDropDownVC.setRoomsData(cRoomsArr: self.meetingRoomsArr)
        self.view.addSubview(self.cDropDownVC.view)
        
    }
    
    //**************   PASS STRING    *********************//
    
    func didSelected(SelectedStr : String, SelectedId : String) {
       switch self.tagVal
       {
        case 1:
            self.R_txtRoom.text = SelectedStr
            self.Re_MeetingParam.r_id_edit = SelectedId
        case 2:
            self.R_TypeLbl.text = SelectedStr
            self.Re_MeetingParam.l_id_edit = SelectedId
        case 4:
            self.R_Lbl_MeetWith.text = SelectedStr
            self.Re_MeetingParam.m_with_edit = SelectedId
       case 5:
        self.R_MeetPlace.text = SelectedStr
        self.getMeetType(mTypeId: SelectedId)
       default:
        print("Defaults")
        }
    }
    
    func ReminderCheckorNot(bStatus : Bool,SelectedId : [String])
    {
        if tagVal == 6
        {
            var gnames = ""
            self.idArr.removeAll()
            
            for (index,value) in SelectedId.enumerated()
            {
                let nIndex = Int(value)
                let lcGroup = self.lblGroupArr[nIndex!]
                let gname = lcGroup.g_name
                
                self.idArr.append(lcGroup.g_id)
             
                if index == SelectedId.count - 1
                {
                    gnames +=  gname!
                }else{
                    gnames =  gname! + ","
                }
                self.R_Groups.text = gnames
            }
            
            if SelectedId.count == 0
            {
               self.R_Groups.text = ""
            }
            
            Re_MeetingParam.g_id_edit = self.getArrofJSonString(cidArr: self.idArr)
            
        }
        else
        {
            if bStatus
            {
                self.bCheckReminderStatus = true
                self.SetCheckBox(bStatus: bStatus)
                Re_MeetingParam.m_reminder_flag_edit = "1"
            }else{
                self.bCheckReminderStatus = false
                self.SetCheckBox(bStatus: bStatus)
                Re_MeetingParam.m_reminder_flag_edit = "0"
            }
            
            print(SelectedId)
            
            Re_MeetingParam.re_id_edit = self.getArrofJSonString(cidArr: SelectedId)
            
           }

    }
  
    @IBAction private func OnStartBtn_Click(_ sender: Any)
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        print(stringDate)
        
        if R_Date.text == stringDate
        {
            self.StatusNum = "1"
            StartMeeting()
            self.BtnsView.isHidden = true
            self.OneBtnView.alpha = 1.0
            self.btnend.setTitle("END", for: .normal)
            self.toast.isShow("Meeting Started Successfully")
            return
        }
        else{
            self.toast.isShow("Meeting can't start upto selected time")
            
        }
  
        }
        
    @IBAction func BtnEnd_Click(_ sender: Any)
    {
        if m_cMeetingStatus == 0
        {
           btnend.setTitle("DECLINE", for: .normal)
           self.RejectMeeting()
          
            
        }else
        {
            btnend.setTitle("END", for: .normal)
            self.StatusNum = "2"
            StartMeeting()
            self.toast.isShow("Meeting Ended Successfully")
            return
            
        }
      
    }

    func RejectMeeting()
    {
        let RejectUrl = "http://kanishkagroups.com/sop/android/rejectMeetingMms.php"
        let Param : [String: Any] = ["logged_in_user_id" : strUserId,
                                     "m_id" : self.m_id!]
        Alamofire.request(RejectUrl, method: .post, parameters: Param).responseString { (resp) in
            print(resp)
            self.toast.isShow("Meeting Rejected and mail is sent to USER")
        }
        
    }
    
    @IBAction private func OnResheduleBtn_Click(_ sender: Any)
    {
        self.toast.isShow("Now You Can Reschedle Above Fields")
        self.UserIntractiontoControl(bStatus: true)
        self.BtnsView.isHidden = true
        self.TwoBtnView.alpha = 1.0
    }
   
   @IBAction func BtnSave_Click(_ sender: Any)
    {
        formValid = true
        if R_subject.text == ""
        {
            self.toast.isShow("Please enter a subject")
            formValid = false
            return
        }
        if R_txtRoom.text == ""
        {
            self.toast.isShow("Please selct a room")
            self.formValid = false
            return
            
        }
        if R_Date.text == ""
        {
            self.toast.isShow("Please select a date")
            self.formValid = false
            return
        }
        if R_StartTime.text == ""
        {
            self.toast.isShow("Please select a start time")
            self.formValid = false
            return
        }
        if R_EndTime.text == ""
        {
            self.toast.isShow("Please select a end time")
            self.formValid = false
            return
        }
        
        if R_Lbl_MeetWith.text == ""
        {
            self.toast.isShow("Please select a meeting with field")
            self.formValid = false
            return
        }
        if R_MeetPlace.text == ""
        {
             self.toast.isShow("Please select a meeting place field")
            self.formValid = false
            return
        }
        if   R_TypeLbl.text == ""
        {
            self.toast.isShow("Please select meeting type")
            self.formValid = false
            return
        }
        if (R_InternalUser.text == "") && (R_Groups.text == "") && (R_OtherUser.text == "")
        {
             self.toast.isShow("Please enter at least any one field from Internal User or other user or Groups")
            self.formValid = false
            return
        }
        
        if   R_invitedBy.text == ""
        {
              self.toast.isShow("Please enter name of Invited by person")
                self.formValid = false
            return
        }
        if  (R_OtherUser.text != "") && (R_OtherUser.text?.isValidEmail() == false )
        {
             self.toast.isShow("Please enter correct Email ID ar other user")
            self.formValid = false
            return
        }
        if (formValid == true)
        {
            self.ApiForReshedule()
        }
    }
    
    @IBAction func BtnCancel_Click(_ sender: Any)
    {
        self.TwoBtnView.alpha = 0
        self.BtnsView.isHidden = false
    }
    
  
    @IBAction func OnDeleteBtn_Click(_ sender: Any)
    {
      
        if BtnDelete.titleLabel?.text == "DELETE"
        {
            let alert = UIAlertController(title: "Alert", message: "Are you sure to cancel this Meeting ?", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.CancleMeeting()
            
        }
       
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                self.BtnsView.isHidden = false
        }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        
        }
      
    }
    

    func getArrofJSonString(cidArr : [String])->String
    {
      
        guard let data = try? JSONSerialization.data(withJSONObject: cidArr, options: []) else {
            return ""
        }
        
        let JsonStringArr = String(data: data, encoding: String.Encoding.utf8)!
        return JsonStringArr
    }
    
    func getArrayFromJSonString(cJsonStr: String)->[String]
    {
        let jsonData = cJsonStr.data(using: .utf8)!

        guard let lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [String] else {
            return ["No Found"]
        }
    
        return lcArrData
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        // activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
          self.view.endEditing(true)
        return true
       
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        self.R_TblView.isHidden = false
        let lnActualLen = textField.text?.count
        let lnNewlen = string.count
        let finalLen = lnActualLen! + lnNewlen - range.length
        print(finalLen)
        
        if finalLen == 0
        {
            self.R_TblView.isHidden = true
        }
        
        if textField == R_InternalUser
        {
            
            if string != ","
            {
                result = result + string
                print(result)
            }
            if string == ""
            {
                result = ""
    
            }
            
            self.tblTopConst.constant = 5
            if result.count > 1
            {
                self.FetchResult(nFinalLen: finalLen)
            }
            bStausField = false
            
        }else if textField == R_invitedBy
        {
            result = result + string
            
            self.tblTopConst.constant = 115
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
        
        print("names = \(FilteredArr)")
        if(nFinalLen == 0){
            result = ""
            self.tblHeightConstraint.constant = 0
        } else {
            self.tblHeightConstraint.constant = 188
        }
        self.R_TblView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.FilteredArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.R_TblView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
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
            self.R_invitedBy.text = self.FilteredArr[indexPath.row] as? String
            
            for (index,lcUser) in self.cUserArr.enumerated()
            {
                if lcUser.user_name == self.R_invitedBy.text
                {
                    Re_MeetingParam.m_invited_by_edit = lcUser.user_id
                    print(Re_MeetingParam.m_invited_by_edit)
                }
            }
            
        }else{
            let stringName = self.FilteredArr[indexPath.row] as! String
            
            if indexPath.row != 0
            {
                name += stringName + ","
                
                self.R_InternalUser.text = name
            }else{
                self.R_InternalUser.text = stringName
                name = stringName
            }
            
            for (index,lcUser) in self.cUserArr.enumerated()
            {
                if lcUser.user_name == stringName
                {
       
                    lcUserArr.append(lcUser.user_id)
                    print(Re_MeetingParam.m_internal_user)
                }
            }
            
            Re_MeetingParam.m_internal_user = self.getArrofJSonString(cidArr: lcUserArr)
        }
        
        self.tblHeightConstraint.constant = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        bSelected = false
        BAllDayunchek = false
        bCheckweeklyStatus = false
        bCheckMonthStatus = false
        Re_MeetingParam.m_reminder_flag_edit = "0"
        lcUserArr.removeAll(keepingCapacity: false)
      
    }
    
    func viewWillDisappear(animated: Bool)
    {
        self.view.endEditing(true)
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func ShowAlert(sTitile: String, cMessage: String)
    {
        let alertController = UIAlertController(title: sTitile, message: cMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            if self.bMeetingStatus
            {
                
                print("OnAlerClick=\(self.Meetingdata)")
                
                let InterfaceVC = self.storyboard?.instantiateViewController(withIdentifier: "InterfaceBuilderViewController") as!
                InterfaceBuilderViewController
                // InterfaceVC.setUserId(cUserId: self.strUserId,cJSON:self.)
                InterfaceVC.setupID(cUserId: self.strUserId)
                self.navigationController?.pushViewController(InterfaceVC, animated: true)
                
            }else{
                print("OK Pressed")
            }
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func BtnMom_Click(_ sender: Any)
    {
        self.cMomVc.view.frame = self.view.bounds
        if let cSelectedStr = self.selectedM_id
        {
            self.cMomVc.setUpData(lcM_id: cSelectedStr)
        }
        if let mom_id = self.momStatus
        {
            self.cMomVc.setData(mM_id: mom_id)
        }
        self.view.addSubview(self.cMomVc.view)
       // self.present(self.cMomVc, animated: true, completion: nil)
        self.cMomVc.view.clipsToBounds = true
        
    }
    
    
    @IBAction private func BtnAttachment_Click(_ sender: Any)
    {
        if self.momStatus == "0"
        {
            let msg : String! = "No MOM available for download"
            self.toast.isShow(msg)
        }else
        {
            self.cFileDocumentVc.view.frame = self.view.bounds
            if let cSelectedStr = self.selectedM_id
            {
                self.cFileDocumentVc.setUpData(mM_id: cSelectedStr)
            }
            self.view.addSubview(self.cFileDocumentVc.view)
            self.cFileDocumentVc.view.clipsToBounds = true
        }
    }
    
    @IBAction func onRoomtxt_Click(_ sender: Any)
    {
        
    }
    
    @IBAction func btnAllDay_Click(_ sender: Any)
    {
        BAllDayunchek = !BAllDayunchek
        
        if BAllDayunchek
        {
            checkAllDayEvent.setImage(UIImage(named:"checkbox"), for: .normal)
            self.R_StartTime.text           = "9.00 AM"
            self.R_EndTime.text             = "7.00 PM"
            Re_MeetingParam.m_start_time_edit   = "09:00:00"
            Re_MeetingParam.m_end_time_edit    = "19:00:00"
            Re_MeetingParam.m_all_day_event_edit = "1"
            self.R_StartTime.isUserInteractionEnabled = false
            self.R_EndTime.isUserInteractionEnabled    = false
        } else {
            self.R_StartTime.text = ""
            self.R_EndTime.text  = ""
            Re_MeetingParam.m_all_day_event_edit = "0"
            self.checkAllDayEvent.setImage(UIImage(named:"unchecked-checkbox"), for: .normal)
            self.R_EndTime.isUserInteractionEnabled = true
            self.R_StartTime.isUserInteractionEnabled = true
        }
    }
    
    
    
}

