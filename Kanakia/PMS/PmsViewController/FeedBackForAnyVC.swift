//
//  FeedBackForAnyVC.swift
//  Kanakia
//
//  Created by user on 21/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class FeedBackForAnyVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, didSelectedDelegate {

    @IBOutlet weak var tblUser: UITableView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var txtFeedbackView: UITextView!
    
    var searchActive = Bool(false)
    var Up_ID : String = ""
    var empData = [AnyObject]()
    private var toast: JYToast!
    var filtered = NSArray()
    var DataArr = NSArray()
     var valid = Bool(true)
    var UserId : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtFeedbackView.layer.borderWidth = 1.0
        txtFeedbackView.layer.borderColor = UIColor.black.cgColor
        txtFeedbackView.delegate = self
        txtFeedbackView.clipsToBounds = true
        txtFeedbackView.layer.cornerRadius = 10
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        backView.addGestureRecognizer(dismissKeyboardGesture)
        searchBar.delegate = self
        initUi()
        tblUser.delegate = self
        tblUser.dataSource = self
        
          self.tblUser.register(UINib(nibName: "teamCell", bundle: nil), forCellReuseIdentifier: "teamCell")
        self.tblUser.isHidden = true
        tblUser.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        txtFeedbackView.text = "Enter Quick Feedback Here.."
        txtFeedbackView.textColor = UIColor.gray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        txtFeedbackView.text = nil
        txtFeedbackView.textColor = UIColor.black
        
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
        
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
                    
                case "iPhone 6S":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y -= 80
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
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
                    
                case "iPhone 6S":
                    if self.view.frame.origin.y != 0
                    {
                        self.view.frame.origin.y += 80
                    }
                    break
                default:
                    print("No Match")
                }
                
            }
        }
    }
    
    func setId(Id: String)
    {
        self.Up_ID = Id
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        getUser()
        let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
        
        self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
        
        print("names = ,\(self.filtered)")
        if(filtered.count == 0)
        {
            tblUser.isHidden = true
            searchActive = false
            
        } else {
            tblUser.isHidden = false
            searchActive = true
            
        }
        
        self.tblUser.reloadData()
        
    }

    
    func getUser()
    {
        let userUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getAllFeedbackUser"
        
        let param : [String: Any] = ["up_id" : self.Up_ID]
        print("UserParam id :", param)
        
        Alamofire.request(userUrl, method: .post, parameters: param).responseJSON { (EmpResp) in
            print(EmpResp)
            let data = EmpResp.result.value as! [String: AnyObject]
            self.empData = data["msg"] as! [AnyObject]
            self.DataArr = self.empData.map ({ $0 }) as NSArray
            print(self.DataArr)
            print("empData", self.empData)
            
            if self.empData.count == 0
            {
                self.toast.isShow("No any team members found")
            }
            self.tblUser.reloadData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive
        {
            return self.filtered.count
        }
        
        return self.empData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let cell = tblUser.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! teamCell
        
        var lcDict: [String: AnyObject]!
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
      //  self.designCell(cView: cell.backView)
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        }else{
            lcDict = self.empData[indexPath.row] as! [String: AnyObject]
        }
        cell.lblEmpName.text = lcDict["user_name"] as? String
        let lcUserName = lcDict["user_name"] as! String
        let firstLetter =  lcUserName.first!
        cell.lblFirstLetter.text = String(describing: firstLetter)
        cell.lblFirstLetter.backgroundColor = getRandomColor()
       cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowOpacity = 0.23
        cView.layer.shadowRadius = 4
    }
    
    func didSelectedRow(cell: teamCell)
    {
        var lcDict: [String: AnyObject]!
        guard let indexPath = self.tblUser.indexPath(for: cell) else { return }
        print("SelectedIndex=", indexPath.row)
        
        lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        self.searchBar.text = lcDict["user_name"] as? String
        
        self.UserId = lcDict["up_id"] as? String
        print("User_id:", self.UserId)
        self.tblUser.isHidden = true
        
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    
    @IBAction func btnCancle_Click(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnOK_Click(_ sender: Any)
    {
        self.view.endEditing(true)
        if searchBar.text == ""
        {
            self.toast.isShow("Please enter a employee name")
            self.valid = false
            self.view.endEditing(true)
        }
        else
        {
            if txtFeedbackView.text == ""
            {
                self.toast.isShow("Please enter a text")
                self.valid = false
                self.view.endEditing(true)
            }
            
            if self.valid == true
            {
                let Tpa_Status : String!
                if self.Up_ID != self.UserId
                {
                    Tpa_Status = "1"
                }else
                {
                    Tpa_Status = "0"
                }
                let Feedbackurl = "http://kanishkagroups.com/sop/pms/index.php/API/submit_any_feedback"
                let Feedparam : [String : Any] =
                    [
                     "up_id" : self.UserId!,
                     "tpf_name" : txtFeedbackView.text!,
                     "tpf_added_by" : self.Up_ID
                ]
                
                print(Feedparam)
                Alamofire.request(Feedbackurl, method: .post, parameters: Feedparam).responseJSON { (addResp) in
                //    print(addResp)
                    self.view.endEditing(true)
                    self.toast.isShow("Your Feedback message has been sent")
                    self.txtFeedbackView.text = ""
                    self.view.removeFromSuperview()
                    
                }
                
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
