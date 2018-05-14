
import UIKit

protocol SelectedStringDelegate
{
    func didSelected(SelectedStr : String, SelectedId : String)
    func ReminderCheckorNot(bStatus : Bool,SelectedId : [String])
    func didSelectedDays(DaysArr : [Days] ,SelectedId : [String],bDaySelected: Bool)
}

class DropDownVC: UIViewController,UITableViewDelegate,UITableViewDataSource,ModalControllerDelegate
{
    @IBOutlet weak var MainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClose: MKButton!
    @IBOutlet weak var tblViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgView: UIView!
    var meetingRoomsArr  = [rooms]()
    var bussinessArr     = [label]()
    var reminderArr      = [reminder]()
    var selectedArr = [String]()
    
    var DayArr          = [Days]()
    var groupsArr        = [group]()
    var bSelected        = Bool(false)
    var cAddMeetingVC = AddMeetingVc()
    var delegate : SelectedStringDelegate?
    var cRemindercell : ReminderCell!
    
    var cDayCell : DayCell!
    var MeetWithArr = [MeetWith]()//"Internal Person","External Person"
    var MeetTypeArr = [MeetType]()//"Internal","External"
    
    var preIndexDay = Int(-1)
    var preIndexGroup = Int(-1)
    var DropDownSelectedStr: String!
    var SelectedId: String!
    var tagVal = Int(0)
    var SelectedindexPath  : IndexPath?
    var VCcell : DataCell!
    var bRemindercheckOrNot = Bool(false)
    var bCheckStatus: Bool!
    var bGroupSelected: Bool!
    var preIndex :Int = -1
    var bFromVc = Int(0)
    
    //var JsonArr: String
    
    var cBussinessLbl : label!
    
    var re_idArr = [String]()
    var g_idArr  = [String]()
    var day_IdArr = [String]()
    var bDaysSelected = Bool(false)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tblView.delegate   = self
        self.tblView.dataSource = self
        
        self.tblView.register(DataCell.nib, forCellReuseIdentifier: DataCell.identifier)
        self.tblView.register(ReminderCell.nib, forCellReuseIdentifier: ReminderCell.identifier)
        self.tblView.register(DayCell.nib, forCellReuseIdentifier: DayCell.identifier)
        
      //  self.meetingRoomsArr.insert(rooms, at: 0)
        
        let cMeetwith1 = MeetWith()
        cMeetwith1.m_With = "Internal Person"
        cMeetwith1.m_Withid = "1"
        self.MeetWithArr.append(cMeetwith1)
        let cMeetWith2 = MeetWith()
        cMeetWith2.m_With = "External Person"
        cMeetWith2.m_Withid = "2"
        self.MeetWithArr.append(cMeetWith2)
        
        let cMeetType1 = MeetType()
        cMeetType1.m_Type = "HO"
        cMeetType1.m_Typeid = "1"
        self.MeetTypeArr.append(cMeetType1)
            let cMeetType2 = MeetType()
        cMeetType2.m_Type = "External "
        cMeetType2.m_Typeid = "2"
        self.MeetTypeArr.append(cMeetType2)
        
         self.DayArr.append(Days(sDayName: "Sunday", dayid: "1", bselected: false))
         self.DayArr.append(Days(sDayName: "Monday", dayid: "2", bselected: false))
         self.DayArr.append(Days(sDayName: "Tuesday", dayid: "3", bselected: false))
         self.DayArr.append(Days(sDayName: "Wendsday", dayid: "4", bselected: false))
         self.DayArr.append(Days(sDayName: "Thursday", dayid: "5", bselected: false))
         self.DayArr.append(Days(sDayName: "Friday", dayid: "6", bselected: false))
         self.DayArr.append(Days(sDayName: "Saturday", dayid: "7", bselected: false))
        
       self.tblView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch tagVal
        {
            case 1:
                return self.bussinessArr.count
            case 2:
                return self.meetingRoomsArr.count
            case 3:
                return self.reminderArr.count
            case 4:
                return self.MeetWithArr.count
            case 5:
                return self.MeetTypeArr.count
            case 6:
                return self.groupsArr.count
            case 7:
                return self.DayArr.count
            default:
                print("Default")
        }
            return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
        switch tagVal
        {
        case 1:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: DataCell.identifier, for: indexPath) as! DataCell
            self.VCcell = cell
            let lblObj = self.bussinessArr[indexPath.row]
            cell.SetBussinesData(cLabel: lblObj)
            self.SetCheckBox(nIndexPath: indexPath)
            return cell
            
        case 2:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: DataCell.identifier, for: indexPath) as! DataCell
            let roomsObj = self.meetingRoomsArr[indexPath.row]
            cell.SetRoomData(cRoom: roomsObj)
            self.VCcell = cell
            self.SetCheckBox(nIndexPath: indexPath)
            return cell
            
        case 3:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: ReminderCell.identifier, for: indexPath) as! ReminderCell
             let reminder = self.reminderArr[indexPath.row]
             cRemindercell = cell
            cell.SetReminderData(cReminder:reminder)
            
            if reminder.re_selected
            {
               cell.btnUnselected.setImage( UIImage(named:"checkbox"), for: .normal)
            }else{
                cell.btnUnselected.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            }
            
            cell.btnUnselected.tag = indexPath.row
            cell.btnUnselected.addTarget(self, action:#selector(checkbtnClick(sender:)), for: .touchUpInside)
             return cell
            
        case 4:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: DataCell.identifier, for: indexPath) as! DataCell
            cell.setMeetingWith(cMeetWith: self.MeetWithArr[indexPath.row])
            self.VCcell = cell
            self.SetCheckBox(nIndexPath: indexPath)
            return cell
            
        case 5:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: DataCell.identifier, for: indexPath) as! DataCell
            cell.setMeetType(cMeetType: self.MeetTypeArr[indexPath.row])
            self.VCcell = cell
            self.SetCheckBox(nIndexPath: indexPath)
            return cell
            
        case 6 :
            let cell = self.tblView.dequeueReusableCell(withIdentifier:  DataCell.identifier, for: indexPath) as! DataCell
            self.VCcell = cell
            let grpObj = self.groupsArr[indexPath.row]
            cell.SetGroupData(cGroup: grpObj)
            
            if grpObj.selected
            {
               cell.accessoryType = .checkmark
            }else{
               cell.accessoryType = .none
            }
            return cell
            
        case 7 :
            let cell = self.tblView.dequeueReusableCell(withIdentifier: DayCell.identifier, for: indexPath) as! DayCell
            let dayPlace = self.DayArr[indexPath.row]
            cDayCell = cell
            cell.SetDayData(cDay: dayPlace)
            if dayPlace.selected
            {
                cell.btnDayUnSelect.setImage( UIImage(named:"checkbox"), for: .normal)
            }else{
                cell.btnDayUnSelect.setImage( UIImage(named:"unchecked-checkbox"), for: .normal)
            }
            cell.btnDayUnSelect.tag = indexPath.row
            cell.btnDayUnSelect.addTarget(self, action:#selector(DaycheckbtnClick(sender:)), for: .touchUpInside)
            return cell
            
            
        default:
            print("Default")
        }
       return UITableViewCell()
    }
    
    func SelectClick(CurrentIndex: Int)
    {
        let cReminder = self.reminderArr[CurrentIndex]
        cReminder.re_selected = !cReminder.re_selected
        
        if self.bFromVc == 1
        {
            if cReminder.re_selected
            {
                preIndex = -1
                cReminder.re_selected = true
                //self.bCheckStatus = true
                preIndex = preIndex + 1
                self.re_idArr.insert(cReminder.re_id, at: preIndex)
            }else{
                
                cReminder.re_selected = false
                self.re_idArr.remove(at: preIndex)
                
            }
        }
        else if self.bFromVc == 2
        {
            
            if cReminder.re_selected
            {
                preIndex = -1
                cReminder.re_selected = true
                preIndex = preIndex + 1
                self.re_idArr.insert(cReminder.re_id, at: preIndex)
            }else{
                
                let cReminder = self.reminderArr[CurrentIndex]
                cReminder.re_selected = false
                let nReminderId = Int(cReminder.re_id)
                
                for (index,value) in self.re_idArr.enumerated()
                {
                    let nIndex = Int(value)
                    
                    if nReminderId == nIndex
                    {
                        self.re_idArr.remove(at: index)
                        print(self.re_idArr)
                    }
                    
                }
            }
            
        }
        
        
        if self.re_idArr.count == 0
        {
            self.bCheckStatus = false
        }else{
            self.bCheckStatus = true
        }
        self.tblView.reloadData()
    }
    
    @objc func checkbtnClick(sender: MKButton)
     {
        let CurrentIndex = sender.tag
        self.SelectClick(CurrentIndex: CurrentIndex)
    }
    
    func DaySelected(nIndex: Int)
    {
        let CurrentIndex = nIndex
        
        let c_days = self.DayArr[CurrentIndex]
        c_days.selected = !c_days.selected
        
        if c_days.selected
        {
            preIndexDay = -1
            c_days.selected = true
            preIndexDay = preIndexDay + 1
            self.day_IdArr.insert(c_days.Day_id, at: preIndexDay)
        }else{
            
            let cDays = self.DayArr[CurrentIndex]
            cDays.selected = false
            let ndayId = Int(cDays.Day_id)
            
            for (index,value) in self.day_IdArr.enumerated()
            {
                let nIndex = Int(value)
                
                if ndayId == nIndex
                {
                    self.day_IdArr.remove(at: index)
                    print(self.day_IdArr)
                }
                
            }
        }
        
        self.tblView.reloadData()
    }
    @objc func DaycheckbtnClick(sender: MKButton)
    {
        let CurrentIndex = sender.tag
        self.DaySelected(nIndex: CurrentIndex)
   }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         self.SelectedindexPath = indexPath
        
        switch tagVal {
        case 1:
            let cBussiness = self.bussinessArr[indexPath.row]
            
            self.SelectedId = cBussiness.l_id
            delegate?.didSelected(SelectedStr : cBussiness.l_name,SelectedId : self.SelectedId)
            self.view.removeFromSuperview()
            
        case 2:
            let cMeetingRooms = self.meetingRoomsArr[indexPath.row]
            self.DropDownSelectedStr = cMeetingRooms.r_Name
            self.SelectedId = cMeetingRooms.r_id
            
            delegate?.didSelected(SelectedStr : cMeetingRooms.r_Name,SelectedId : self.SelectedId)
            self.view.removeFromSuperview()
        case 3:
            _ = self.reminderArr[indexPath.row]
            self.SelectClick(CurrentIndex: indexPath.row)
         
        case 4:
                let cMeethWith = self.MeetWithArr[indexPath.row]
                self.SelectedId = cMeethWith.m_Withid
                self.DropDownSelectedStr = cMeethWith.m_With
            delegate?.didSelected(SelectedStr : self.DropDownSelectedStr,SelectedId : self.SelectedId)
            self.view.removeFromSuperview()
        case 5:
               let cMeetType = self.MeetTypeArr[indexPath.row]
                self.SelectedId = cMeetType.m_Typeid
                self.DropDownSelectedStr = cMeetType.m_Type
                delegate?.didSelected(SelectedStr : self.DropDownSelectedStr,SelectedId : self.SelectedId)
            self.view.removeFromSuperview()
        case 6:
            let cGroups = self.groupsArr[indexPath.row]
            
                self.DropDownSelectedStr = cGroups.g_name
                self.SelectedId          = cGroups.g_id
                 cGroups.selected = !cGroups.selected
           
            if cGroups.selected
            {
                preIndexGroup = preIndexGroup + 1
                self.g_idArr.insert(String(indexPath.row), at: preIndexGroup)
            }else{
                
                self.g_idArr.remove(at: preIndexGroup)
                preIndexGroup = preIndexGroup - 1
            }
            print(self.g_idArr)
            
        case 7:
            let cDay = self.DayArr[indexPath.row]
            self.DropDownSelectedStr = cDay.Day_id
            self.DaySelected(nIndex: indexPath.row)
        default:
            print("Default")
        }
        
        self.tblView.reloadData()
        
    }
    
   func SetCheckBox(nIndexPath : IndexPath)
    {
        if SelectedindexPath?.row == nIndexPath.row
        {
            self.VCcell.accessoryType = .checkmark
        }else{
            self.VCcell.accessoryType = .none
        }
    }
    
    func setLblData(LblDataArr : [label])
    {
        self.tagVal = 1
        self.bussinessArr = LblDataArr
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: self.bussinessArr.count)
       
    }
    func setTableViewHeight(ArrCount: Int)
    {
        let tblHeight = CGFloat(50 * ArrCount)
        self.tblViewHeightConstraint.constant = tblHeight
        self.MainViewHeightConstraint.constant = tblHeight
    }
    
    func setRoomsData(cRoomsArr : [rooms])
    {
        self.tagVal = 2
       self.meetingRoomsArr = cRoomsArr
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: self.meetingRoomsArr.count)
    }
    
    func setAddmeetingReminder(reminderArr: [reminder], bCheckReminderStatus: Bool,reid: [String])
    {
        bFromVc = 1
        self.tagVal = 3
        self.reminderArr = reminderArr
        self.bCheckStatus = bCheckReminderStatus
        print(reid)
        if self.bCheckStatus
        {
            if reid.count == 1
            {
                for (index, _) in self.reminderArr.enumerated()
                {
                    let cReminder = self.reminderArr[index]
                    if index == 3
                    {
                        preIndex = 0
                        cReminder.re_selected = true
                        self.re_idArr = reid
                    }
                    
                }
            }
        
        }else{
               for (index , _) in reminderArr.enumerated()
                {
                    
                    let cReminder = self.reminderArr[index]
                     cReminder.re_selected = false
                   self.re_idArr.removeAll()
            }
        }
        
      
        
        print(self.re_idArr)
        self.tblView.reloadData()
    }
    
    func setReminder(reminderArr: [reminder], bCheckReminderStatus: Bool,SelectedIdArr : [String])
    {
        
        bFromVc = 2
        self.tagVal = 3
        self.reminderArr = reminderArr
        self.bCheckStatus = bCheckReminderStatus
        self.selectedArr = SelectedIdArr
        print(SelectedIdArr)
        
        if self.bCheckStatus
        {
            preIndex = -1
            
            for (_, value) in SelectedIdArr.enumerated()
             {
                
                let nIndex = Int(value)
                for lcReminder in self.reminderArr
                {
                    if Int(lcReminder.re_id) == nIndex
                    {
                        lcReminder.re_selected = true
                    }
                }
                
            }
           self.re_idArr = SelectedIdArr
        }
        else
        {
            for (index , _) in reminderArr.enumerated()
            {
                
                let cReminder = self.reminderArr[index]
                cReminder.re_selected = false
                self.re_idArr.removeAll()
            }
    }

        
        print(self.re_idArr)
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: self.reminderArr.count)
    }



    
    func setMeetWith()
    {
        self.tagVal = 4
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: 2)
    }
    
    func setMeetType()
    {
        self.tagVal = 5
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: 2)
    }
    func setGroupArr(cGroupArr : [group])
    {
        self.tagVal = 6
        self.groupsArr = cGroupArr
        self.tblView.reloadData()
        self.setTableViewHeight(ArrCount: self.groupsArr.count)
    }
   
    func setData(cDayIdArr: [String])
    {
        preIndexDay = -1
        self.tagVal = 7
       // print(cDayIdArr)
        
        for (_,value) in cDayIdArr.enumerated()
        {
            preIndexDay = preIndexDay + 1
            let nId = Int(value)! - 1
            let lcDayid = self.DayArr[nId]
            lcDayid.selected = true
          
            if self.day_IdArr.count == 0
            {
                self.day_IdArr.insert(lcDayid.Day_id, at: preIndexDay)
            }
            
//            if self.day_IdArr.count > 1
//            {
//                 self.day_IdArr.insert(lcDayid.Day_id, at: preIndexDay)
//            }
        }
        
        print(self.day_IdArr)
        self.tblView.reloadData()
    }
   
    
    @IBAction func onClose_Click(_ sender: Any)
    {
        if tagVal == 3
        {
            delegate?.ReminderCheckorNot(bStatus : self.bCheckStatus,SelectedId : self.re_idArr)
       }
        
        if tagVal == 6
        {
            delegate?.ReminderCheckorNot(bStatus : false,SelectedId : self.g_idArr)
            
        }
       
        if tagVal == 7
        {
            delegate?.didSelectedDays(DaysArr: self.DayArr, SelectedId: self.day_IdArr, bDaySelected: bDaysSelected)
            
        }
        
        self.view.removeFromSuperview()
 }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.DesignControl()
    }
    
    func DesignControl()
    {
        self.btnClose.layer.shadowColor = UIColor.black.cgColor
        self.btnClose.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.btnClose.layer.masksToBounds = false
        self.btnClose.layer.shadowRadius = 1.0
        self.btnClose.layer.shadowOpacity = 0.5
        self.btnClose.backgroundColor = UIColor.white
        self.btnClose.layer.cornerRadius = self.btnClose.frame.width / 2
        
    }
   
}
