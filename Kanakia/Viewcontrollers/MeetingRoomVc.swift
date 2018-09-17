//
//  MeetingRoomVc.swift
//  MMSproject
//
//  Created by user on 01/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire


class MeetingRoomVc: UIViewController,ModalControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet weak var ActivityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var CollViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var collView: UICollectionView!
 
    @IBOutlet weak var CheckmarkImg: UIImageView!
    @IBOutlet weak var heightConstraint     : NSLayoutConstraint!
    @IBOutlet weak var downArrow            : MKButton!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet weak var lblSelectMeeting     : UILabel!
    @IBOutlet weak var mainView             : UIView!
  
    @IBOutlet weak var txtDate: MKTextField!
    
    let ViewCon            = ViewController()
    var meetingRoomsArr    = [rooms]()
    var meetRoomIdArr      = [rooms]()
    var SelectedindexPath  = Int(0)
    var rowHeight          = Int(44)
    var upBtn              = UIButton()
    var bStatus            = Bool(false)
    var selectedRoomStr : String?
   
    var JSonDict = [String: AnyObject]()
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var m_id : String!
    var DateStr : String?
    var ResponceDict = [String: AnyObject]()
    var dictArrResp = [AnyObject]()
    var InvitedInfoArr = [InvitedInfo]()
    var r_id: String!
    var Meetingdata: [AnyObject]! = [AnyObject]()
    var firstIndex = Bool(true)
    var nMeeting = Int(0)
    var indexPath = Int(-1)
    private var toast: JYToast!
    
    var imgArr = [String]()
    
    var DateArr = [String]()
    
    
    var strUserId : String = ""

    func StringFromDate(nDate: Date) -> String
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: nDate)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
    
        self.firstIndex = true
        self.navigationController?.navigationBar.isHidden = false
        self.tblView.dataSource  = self
        self.tblView.delegate    = self

        self.tblView.register(ResponceCell.nib, forCellReuseIdentifier: ResponceCell.identifier)
        self.collView.dataSource = self
        self.collView.delegate = self
        self.tblView.isHidden = true
        self.txtDate.delegate    = self
        self.DesignTextfield(txtField: txtDate)

        mainView.layer.shadowOpacity = 0.7
        mainView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        mainView.layer.shadowRadius  = 15.0
        mainView.layer.shadowColor   = UIColor.white.cgColor
        mainView.layer.cornerRadius  = 4
        mainView.layer.masksToBounds = false
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        self.txtDate.text = stringDate
        self.DateStr = stringDate
        
        initUi()
        createDatePicker()
      
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    private func initUi() {
        toast = JYToast()
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            let model = UIDevice.current.model
            print("\(UIDevice().type.rawValue)")
            
            if model == "iPad"
            {
                switch UIDevice().type.rawValue
                {
                 case "simulator/sandbox","iPad 5":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 150
                    }
                    
                    break
                 case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                     self.view.frame.origin.y -= 100
                    break
                default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 60
                    }
                    break
                    
                case "iPhone 6 Plus":
                    if self.view.frame.origin.y == 0
                    {
                        self.view.frame.origin.y -= 300
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            let model = UIDevice.current.model
            print("\(UIDevice().type.rawValue)")
            
            if model == "iPad"
            {
                switch UIDevice().type.rawValue
                {
                case "simulator/sandbox","iPad 5":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 150
                    }
                    break
                case "iPad Air 2","iPad Air 1","iPad Pro 9.7\" cellular":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 100
                    }
                    break
              
                default:
                    print("No Match")
                }
                
            }else{
                
                switch UIDevice().type.rawValue
                {
                case "iPhone 5S","iPhone SE":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 60
                    }
                    break
                    
                case "iPhone 6 Plus":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 300
                    }
                    break
                    
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    func rrfetchAPI()
    {
        self.nMeeting = 1
        let parameteres = ["user_id" : self.strUserId]
        APIManager().getMeetingDetails(params: parameteres, nGetMeeting: 1)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        SelectedindexPath = 0
        self.ActivityIndicatorView.isHidden = true
       //self.fetchAPI()
        self.SetUpAPI()
        meetingRoomsArr.removeAll()
        imgArr.removeAll()
        print(imgArr.count)
        self.r_id = "0"
        FetchData()
        
    }
    

    func DesignTextfield(txtField : MKTextField)
    {
        txtField.delegate         = self
        txtField.layer.borderColor             = UIColor.clear.cgColor
        txtField.floatingLabelBottomMargin     = 4
        txtField.floatingPlaceholderEnabled    = true
        txtField.bottomBorderWidth             = 0.5
        txtField.bottomBorderEnabled           = true
        txtField.tintColor = UIColor.blue
        txtField.minimumFontSize = 20.0
    
    }

    func SetUpAPI()
    {
       
        let modal = ModalController.sharedInstance
        modal.delegate = self
        APIManager().GetMMS()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func AddMeetingBtnClick(_ sender: Any)
    {
        let cAddmeeting = storyboard?.instantiateViewController(withIdentifier: "AddMeetingVc") as! AddMeetingVc

        if let cSelectedStr = self.selectedRoomStr
        {
   
        }
        
        cAddmeeting.selectedRoomId = self.r_id
        cAddmeeting.setUpData(DictData: self.JSonDict)
        navigationController?.pushViewController(cAddmeeting, animated: true)
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.meetingRoomsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = self.collView.dequeueReusableCell(withReuseIdentifier: "VenueCell", for: indexPath) as! VenueCell

    
       let room = self.meetingRoomsArr[indexPath.row]
        cell.venueImg.image = UIImage(named: imgArr[indexPath.row])
        
        if SelectedindexPath == indexPath.row
        {
            cell.CheckMarkImg.isHidden = false
        }else{
            if indexPath.row != 0
            {
                 cell.CheckMarkImg.isHidden = true
            }
           
        }

        cell.setData(room: room)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print(indexPath.item)
        let room = self.meetingRoomsArr[indexPath.item]
        self.r_id = room.r_id
        self.SelectedindexPath = indexPath.row
        self.collView.reloadData()
        FetchData()
    }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.InvitedInfoArr.count
  }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "ResponceCell", for: indexPath) as! ResponceCell
        let invitedInfo = self.InvitedInfoArr[indexPath.row]
        cell.getData(invited: invitedInfo)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    
    func JsonDetails(details detail: [String: AnyObject])
    {
    
        
        self.JSonDict = detail
        let roomDict = detail["rooms"] as! [[String: AnyObject]]
      
       for lcRoom in roomDict
        {
             let lcrooms = rooms()
            lcrooms.r_Name = lcRoom["r_name"] as! String
            lcrooms.r_id   = lcRoom["r_id"] as! String
            lcrooms.r_tv_flag = lcRoom["r_tv_flag"] as! String
            
            lcrooms.Selected = false
            meetingRoomsArr.append(lcrooms)
        }
        
        let lcrooms = rooms()
        lcrooms.r_Name = "Other"
        lcrooms.r_id = "0"
        lcrooms.r_tv_flag = ""
       meetingRoomsArr.insert(lcrooms, at: 0)
        print("Count = ", meetingRoomsArr.count)
        
        for (index,value) in meetingRoomsArr.enumerated()
        {
            let lcroomsName = meetingRoomsArr[index]
            self.AppendImg(cName: lcroomsName.r_Name)
        }
       
        self.collView.reloadData()
    }
    
    func AppendImg(cName : String)
    {
        if cName == "Other"
        {
            imgArr.append("other")
            
        }else if cName == "Sun" {
            imgArr.append("sun")
            
        }else if cName == "Moon"
        {
            imgArr.append("moon")
            
        }else if cName == "Venus" {
            imgArr.append("venus")
        }
        else if cName == "Galaxy" {
            imgArr.append("galaxy")
            
        }else if cName == "Mars"
        {
            imgArr.append("mars")
            
        }else if cName == "Jupiter" {
            imgArr.append("jupiter")
            
        }else if cName == "Saturn"
        {
            imgArr.append("saturn")
            
        }else if cName == "Neptune" {
            imgArr.append("neptune")
        }
        else if cName == "Uranus"
        {
            imgArr.append("uranus")
        }
    }
    
    
  
    func errorReceived(error: String) {
        showAlert(error)
    }
    
    //MARK: - ALERT
    func showAlert(_ message:String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title:"", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            let okBtn :UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) in
               
            })
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createDatePicker()
    {
        _ = Date()
        
        datepicker.datePickerMode = .date
        toolBar.sizeToFit()
        let barBtnItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePresses))
        toolBar.setItems([barBtnItem], animated: false)
        txtDate.inputAccessoryView = toolBar
        txtDate.inputView = datepicker
     
    }
    
    @objc func donePresses()
    {
       
       let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        txtDate.text = dateFormatter.string(from: datepicker.date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.DateStr = self.convertDateFormater(dateFormatter.string(from: datepicker.date))
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
  

    func FetchData()
    {
        if let lcdateStr = self.DateStr
        {
            if let lcrid = self.r_id
            {
            let params: [String: String] =
            [
                "logged_in_user_id" : strUserId,
                "date" : lcdateStr,
                "r_id" : lcrid
            ]
        self.nMeeting = 2
         APIManager().getMeetingDetails(params: params, nGetMeeting: self.nMeeting)
       
        }
    }
}

    @IBAction func MyMeetingsBtn_Click(_ sender: Any)
    {

        let vc = storyboard?.instantiateViewController(withIdentifier: "MyMeetingsVc") as! MyMeetingsVc
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func MeetingDetails(Details: [AnyObject])
     {
        if self.nMeeting == 1
        {
            self.Meetingdata = Details
            self.setupPreviousMeetings(index: 0)
            
            
        }else{
            self.InvitedInfoArr.removeAll()
            
            if Details.count == 0
            {
                 self.tblView.isHidden = true
                    self.toast.isShow("No any meeting added for this date")
                    return
               }else{
                for lcDict in Details
                {
                    self.tblView.isHidden = false
                    let lcInvitedInfo = InvitedInfo()
                    lcInvitedInfo.invitedNm = lcDict["m_invited_by_name"] as! String
                    lcInvitedInfo.Start_time = lcDict["m_start_time"] as! String
                    lcInvitedInfo.End_time = lcDict["m_end_time"] as! String
                    self.InvitedInfoArr.append(lcInvitedInfo)
                    
                }
            }
            
            
            self.tblView.reloadData()
        }
   }
    
    @IBAction func OpenCalenderOn_Click(_ sender: Any)
    {
        self.ActivityIndicatorView.isHidden = false
        self.ActivityIndicatorView.hidesWhenStopped = false
        self.ActivityIndicatorView.startAnimating()
        //ModalController.sharedInstance.OpenCalenderVC(cMeetingRoomVc: self, cMeeingData: self.Meetingdata!)
        
        let InterfaceVC = storyboard?.instantiateViewController(withIdentifier: "InterfaceBuilderViewController") as!
        InterfaceBuilderViewController
        
        InterfaceVC.setUserId(cUserId: self.strUserId,cJSON: self.JSonDict)
        navigationController?.pushViewController(InterfaceVC, animated: true)
   }
    
   
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    

    
    func setupPreviousMeetings(index: Int)
    {

            let cParams:[String:String] = [
                "user_id": strUserId,
                "date": self.DateArr[index]//lcDate
            ]
            let index = index + 1
          print(cParams)
            let url = "http://kanishkagroups.com/sop/android/get_meeting_date_wise_ios.php"

            Alamofire.request(url, method: .post, parameters: cParams).responseJSON { (resp) in

                if let JSON = resp.result.value
                {

                    let maindict = JSON as! [String: AnyObject]
                    let responseDictArr = maindict["data"] as! [AnyObject]
  

                    print("Respons", responseDictArr)
                    
                    if index < self.DateArr.count
                    {
                        self.setupPreviousMeetings(index: index)
                    }

                }
        }
    }
    
    func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        
     }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
