//
//  SearchAllMeetingsVc.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 4/15/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SVProgressHUD

protocol SearchMeetingProtocol {
    func moveToback(meetingArr : [AnyObject])
    
}

class SearchMeetings : Decodable
{
    let meetings : [Meetings]?
}

class Meetings : Decodable
{
    var m_date : String
    var m_location : String?
    var m_subject : String
    var r_name : String?
    var sr_no : String
    var user_name : String
}

class SearchAllMeetingsVc: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtDate: MKTextField!
    @IBOutlet weak var txtYear: MKTextField!
    @IBOutlet weak var txtbookBy: MKTextField!
    @IBOutlet weak var txtLocation: MKTextField!
    @IBOutlet weak var txtRoom: MKTextField!
    
    @IBOutlet weak var txtSubject: MKTextField!
    let dropdownYear = DropDown()
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var DateStr = String()
   // var m_cMeeting = [Meetings]()
    var m_cMeeting = [AnyObject]()
    var delegate : SearchMeetingProtocol?
    var toast = JYToast()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        view.isOpaque = false
        
        DesignTextfield(txtField: txtSubject)
        DesignTextfield(txtField: txtDate)
        DesignTextfield(txtField: txtYear)
        DesignTextfield(txtField: txtbookBy)
        DesignTextfield(txtField: txtLocation)
        DesignTextfield(txtField: txtRoom)
        
        dropdownYear.anchorView = txtYear
        dropdownYear.direction = .top
        dropdownYear.bottomOffset = CGPoint(x: 0, y:(dropdownYear.anchorView?.plainView.bounds.height)!)
        dropdownYear.dataSource = ["2018", "2019", "2020"]
        createDatePicker()
        
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
 
    @IBAction func btnClose_onClick(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearch_onClick(_ sender: Any)
    {
        fetchMettings()
    }
    
    @IBAction func btnReset_onClick(_ sender: Any)
    {
        self.txtSubject.text = ""
        self.txtDate.text = ""
        self.txtRoom.text = ""
        self.txtLocation.text = ""
        self.txtbookBy.text = ""
    }
    
    func fetchMettings()
    {
        let Subject = self.txtSubject.text ?? ""
        let Date = self.DateStr ?? ""
        let Room = self.txtRoom.text ?? ""
        let Location = self.txtLocation.text ?? ""
        let BookedBy = self.txtbookBy.text ?? ""
        let Year  = self.txtYear.text
        
       let trimSubject = Subject.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimRoom = Room.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimLocation = Location.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimBookedBy = BookedBy.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let Api = "http://kanishkagroups.com/sop/mms/index.php/Meetings/Search?subject=\(trimSubject)&date=\(Date)&room_id=\(trimRoom)&location=\(trimLocation)&bookedby=\(trimBookedBy)&year=\(Year!)&mobile=1"
        
        print(Api)
        OperationQueue.main.addOperation {
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.gray)
            SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
            SVProgressHUD.show()
        }
        
        Alamofire.request(Api, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            OperationQueue.main.addOperation {
                SVProgressHUD.dismiss()
            }
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                self.m_cMeeting = json["meetings"] as! [AnyObject]
                
                self.delegate?.moveToback(meetingArr: self.m_cMeeting)
                
                self.dismiss(animated: true, completion: nil)
               
                break
                
            case .failure(_):
                print("Something went wrong")
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtYear
        {
            view.endEditing(true)
            dropdownYear.show()
            dropdownYear.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                self.txtYear.text = item
                
            }
        }
        
        if textField == txtDate
        {
            self.txtSubject.text = ""
        }
    }
}
