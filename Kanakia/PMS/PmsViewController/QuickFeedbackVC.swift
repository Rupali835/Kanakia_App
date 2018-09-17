//
//  QuickFeedbackVC.swift
//  Kanakia SOP
//
//  Created by user on 14/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class QuickFeedbackVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate,didSelectedDelegate, UITextViewDelegate
{

    @IBOutlet weak var lblPendingCount: UILabel!
    @IBOutlet weak var btnBehaviour: UIButton!
    
    @IBOutlet weak var btnTechnical: UIButton!
    @IBOutlet weak var checkBehavebtn: UIButton!
    @IBOutlet weak var checkTechBtn: UIButton!
    @IBOutlet weak var PendingView: UIView!
    @IBOutlet weak var TeamView: UIView!
    @IBOutlet weak var TrainingView: UIView!
    @IBOutlet weak var txtTraining: UITextView!
    @IBOutlet weak var txtFeedback: UITextView!
  
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var btnFeedback: UIButton!
    @IBOutlet weak var btnPendingApp: UIButton!
    @IBOutlet weak var btnTeamReview: UIButton!
    @IBOutlet weak var lblTraining: UILabel!
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet weak var lblAchive: UILabel!
    @IBOutlet weak var btnAchive: UIButton!
    @IBOutlet weak var btnKra: UIButton!
    
    var strUserNm : String = ""
    var cAddTraining : AddTrainingMdVc!
    var searchActive = Bool(false)
    var filtered = NSArray()
    var DataArr = NSArray()
    var ManagerDataArr = NSArray()
    var Up_id: String = ""
    var Up_type : String = ""
    var Msg = [AnyObject]()
    var UserId : String!
    var valid = Bool(true)
     private var toast: JYToast!
    var Check = Bool(true)
    var Tpt_Type : String!
    var cFeedback : FeedBackForAnyVC!
    
    func HiddenControl(bStatus: Bool)
    {
        self.txtFeedback.isHidden   = bStatus
        self.txtTraining.isHidden = bStatus
        self.btnFeedback.isHidden   = bStatus
        self.btnPendingApp.isHidden = bStatus
        self.lblAchive.isHidden = bStatus
        self.lblFeedback.isHidden = bStatus
        self.btnTeamReview.isHidden = bStatus
        self.btnPendingApp.isHidden = bStatus
        self.btnFeedback.isHidden = bStatus
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserNm = userDict["user_name"] as! String

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        self.txtTraining.delegate = self
        self.txtFeedback.delegate = self
        self.txtFeedback.text = "Enter a Quick feedback here"
        self.txtTraining.text = "Enter a Training here"
        self.txtFeedback.textColor = UIColor.gray
        self.txtTraining.textColor = UIColor.gray
        tblSearch.delegate = self
        tblSearch.dataSource = self
        searchBar.delegate = self
        self.tblSearch.isHidden = true
       tblSearch.separatorStyle = .none
       print("Valid", valid)
        self.tblSearch.register(UINib(nibName: "teamCell", bundle: nil), forCellReuseIdentifier: "teamCell")

        getPendingCount()
        txtFeedback.layer.cornerRadius = 5
        txtFeedback.layer.borderWidth = 1.0
        txtFeedback.layer.borderColor = UIColor.purple.cgColor
        
        txtTraining.layer.cornerRadius = 5
        txtTraining.layer.borderWidth = 1.0
        txtTraining.layer.borderColor = UIColor.purple.cgColor
        
        
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        self.dropShadow(cView: TrainingView)
        self.dropShadow(cView: PendingView)
        self.dropShadow(cView: TeamView)
        
        view.addGestureRecognizer(tap)
        
        let button1 = UIBarButtonItem(image: UIImage(named: "MSG"), style: .plain, target: self, action: #selector(btnChat_Click))
        self.navigationItem.rightBarButtonItem  = button1
        
    }

   
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == txtFeedback{
            txtFeedback.text = nil
            txtFeedback.textColor = UIColor.black
        }
        else{
            txtTraining.text = nil
            txtTraining.textColor = UIColor.black
        }
       
    }
    
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
         self.view.endEditing(true)
    }
    
    override func awakeFromNib()
    {
        self.cAddTraining = self.storyboard?.instantiateViewController(withIdentifier: "AddTrainingMdVc") as! AddTrainingMdVc
        self.cFeedback = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackForAnyVC") as! FeedBackForAnyVC
    }
    
    func setupData(cId: String, cUpType: String)
    {
        self.Up_id = cId
        self.Up_type = cUpType
        print("UpType", self.Up_type)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowOpacity = 0.23
        cView.layer.shadowRadius = 4
    }
    
    func dropShadow(cView : UIView) {
    
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white

    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func getAllUserMd()
    {
        let getMdUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getAllUserMD"
        let param : [String: Any] = ["up_id" : self.Up_id]
        print("UserParam id :", param)
        
        Alamofire.request(getMdUrl, method: .post, parameters: param).responseJSON { (dataAchive) in
            
            let data = dataAchive.result.value as! [String: AnyObject]
            self.Msg = data["msg"] as! [AnyObject]
            self.DataArr = self.Msg.map ({ $0 }) as NSArray
            print(self.DataArr)
            
            if self.Msg.count == 0
            {
                self.toast.isShow("No data found")
            }
            self.tblSearch.reloadData()
            
        }
        
    }
    

    func getManagerUserData()
        {
        let getMdUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getFullTeamForManager"
        let param : [String: Any] = ["up_id" : self.Up_id]
        print("UserParam id :", param)
    
        Alamofire.request(getMdUrl, method: .post, parameters: param).responseJSON { (dataAchive) in
    
        self.Msg = dataAchive.result.value as! [AnyObject]
            
            let myDict = ["up_id" : self.Up_id, "user_name" : self.strUserNm]
            self.Msg.append(myDict as AnyObject)
            
        self.ManagerDataArr = self.Msg.map ({ $0 }) as NSArray
        print(self.ManagerDataArr)
    
        if self.Msg.count == 0
        {
            self.toast.isShow("No data found")
        }
            self.tblSearch.reloadData()
    
        }
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
        
        if self.Up_type == "1"
        {
            getAllUserMd()
            let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
            
            self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
            
            print("names = ,\(self.filtered)")
            if(filtered.count == 0)
            {
                searchActive = false
                self.tblSearch.isHidden = true
                //self.HiddenControl(bStatus: false)
                
            } else {
                searchActive = true
                self.tblSearch.isHidden = false
                //self.HiddenControl(bStatus: true)
            }
            self.tblSearch.reloadData()
        }
        
        if self.Up_type == "2"
        {
            getAllUserMd()
            let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
            
            self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
            
            print("names = ,\(self.filtered)")
            if(filtered.count == 0)
            {
                searchActive = false
                self.tblSearch.isHidden = true
                //self.HiddenControl(bStatus: false)
                
            } else {
                searchActive = true
                self.tblSearch.isHidden = false
                //self.HiddenControl(bStatus: true)
            }
            self.tblSearch.reloadData()
        }
        
        
        if self.Up_type == "3"
        {
            getManagerUserData()
            let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
            
            self.filtered = self.ManagerDataArr.filter { predicate.evaluate(with: $0) } as NSArray
            
            print("names = ,\(self.filtered)")
            if(filtered.count == 0)
            {
                searchActive = false
                self.tblSearch.isHidden = true
                //self.HiddenControl(bStatus: false)
                
            } else {
                searchActive = true
                self.tblSearch.isHidden = false
                //self.HiddenControl(bStatus: true)
            }
            self.tblSearch.reloadData()
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.filtered.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSearch.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! teamCell
        
        var lcDict: [String: AnyObject]!
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        }else{
            lcDict = self.Msg[indexPath.row] as! [String: AnyObject]
        }
        cell.lblEmpName.text = lcDict["user_name"] as? String
        let lcUserName = lcDict["user_name"] as! String
        let firstLetter =  lcUserName.first!
        cell.lblFirstLetter.text = String(describing: firstLetter)
        cell.lblFirstLetter.backgroundColor = getRandomColor()
       cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
        
    }
    @IBAction func btnKraKpi_Click(_ sender: Any)
    {
           self.view.endEditing(true)
        if searchBar.text == ""
        {
            self.toast.isShow("Please enter a employee name")
            self.valid = false
        }
        else 
        {
        let kraVc = storyboard?.instantiateViewController(withIdentifier: "Kra_FeedbackVc") as! Kra_FeedbackVc
             kraVc.setupData(cId: self.UserId)
            kraVc.setEmpName(cNm: searchBar.text!)
            kraVc.Check = true
        navigationController?.pushViewController(kraVc, animated: true)
        }
        
    }
  
    
    @IBAction func sendFeedback_Click(_ sender: Any)
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
            if txtFeedback.text == ""
            {
                self.toast.isShow("Please enter a text")
                self.valid = false
                  self.view.endEditing(true)
            }
            
            if self.valid == true
            {
                let Tpa_Status : String!
                if self.Up_id != self.UserId
                {
                    Tpa_Status = "1"
                }else
                {
                    Tpa_Status = "0"
                }
                let Feedbackurl = "http://kanishkagroups.com/sop/pms/index.php/API/addFeedback"
                let Feedparam : [String : Any] =
                    [ "up_id" : self.UserId,
                      "tpf_name" : txtFeedback.text,
                      "tpf_status" : Tpa_Status,
                      "tpf_added_by" : self.Up_id
                ]
                
                print(Feedparam)
                Alamofire.request(Feedbackurl, method: .post, parameters: Feedparam).responseJSON { (addResp) in
                    print(addResp)
                     self.view.endEditing(true)
                    self.toast.isShow("Your Feedback message has been sent")
                    self.txtFeedback.text = ""
                    
                    
                }

            }
        }
       
    }
    
    
    @IBAction func BtnMdPendingApproval(_ sender: Any)
    {
        let getDataVc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "PendingApprovalVc") as! PendingApprovalVc
        navigationController?.pushViewController(getDataVc, animated: true)
    }
    
    @IBAction func btnMdTeamReview(_ sender: Any)
    {
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "ListOfMyTeamVC") as! ListOfMyTeamVC
        
        navigationController?.pushViewController(Fvc, animated: true)
    }
    
    func didSelectedRow(cell: teamCell)
    {
        var lcDict: [String: AnyObject]!
      guard let indexPath = self.tblSearch.indexPath(for: cell) else { return }
        print("SelectedIndex=", indexPath.row)
        
        lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        self.searchBar.text = lcDict["user_name"] as? String
        
        self.UserId = lcDict["up_id"] as? String
        print("User_id:", self.UserId)
        self.tblSearch.isHidden = true
        
    }
    
    @IBAction func btnTechnical_Click(_ sender: Any)
    {
        self.Tpt_Type = "1"
        self.btnTechnical.isSelected = true
        checkTechBtn.setImage(UIImage(named:"radiobutton_selected"), for: .normal)
        checkBehavebtn.setImage(UIImage(named:"radiobuttom_unselected"), for: .normal)
    }
    
    
    @IBAction func btnBehav_Click(_ sender: Any)
    {
        self.Tpt_Type = "2"
        self.btnBehaviour.isSelected = true
        checkBehavebtn.setImage(UIImage(named:"radiobutton_selected"), for: .normal)
        checkTechBtn.setImage(UIImage(named:"radiobuttom_unselected"), for: .normal)
    }
    
    @IBAction func SendTraining_Click(_ sender: Any)
    {
        self.valid = true
         self.view.endEditing(true)
        if searchBar.text == ""
        {
            self.toast.isShow("Please enter a employee name")
            self.view.endEditing(true)
            self.valid = false
            return
        }
        
            if txtTraining.text == ""
            {
                self.toast.isShow("Please enter a text")
                self.valid = false
                self.view.endEditing(true)
                return
            }
            
            if (self.btnBehaviour.isSelected == false) && (self.btnTechnical.isSelected == false)
            {
                self.toast.isShow("Please select type of Training i.e. Technical or behavioural")
                self.valid = false
                self.view.endEditing(true)
                return
            }
            if self.valid == true
            {
                
                let Tpa_Status : String!
                if self.Up_id != self.UserId
                {
                    Tpa_Status = "1"
                }else
                {
                    Tpa_Status = "0"
                }
                
       //         if self.valid == true
      //          {
                    let url = "http://kanishkagroups.com/sop/pms/index.php/API/addTraining"
                    let param : [String: Any] =
                        [        "up_id" : self.UserId,
                                 "tpt_name" : txtTraining.text,
                                 "tpt_status" : Tpa_Status,
                                 "tpt_added_by" : self.Up_id,
                                 "tpt_type" : self.Tpt_Type
                    ]
                    
                    print("Param =", param)
                    Alamofire.request(url, method: .post, parameters: param).responseJSON { (addResp) in
                        print(addResp)
                        self.txtTraining.text = ""
                 
                        self.view.endEditing(true)
                        self.toast.isShow("Your Training message has been sent")
                        
                        
                    }
    
            }
 
    }
    
    func getPendingCount()
    {
        let countUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getPendingApprovalsCount"
        let param = ["up_id" : self.Up_id]
        print("Parameter", param)
        Alamofire.request(countUrl, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            let number = resp.result.value as! Int
            if number == 0
            {
                self.lblPendingCount.text = "0"
            }else{
                print("Count", number)
                self.lblPendingCount.text = "(" + "\(number)" + ")"          }
            
        }
    }

    
    @IBAction func btnChat_Click(_ sender: Any)
    {
        self.cFeedback.view.frame = self.view.frame
        self.view.addSubview(self.cFeedback.view)
        self.cFeedback.view.clipsToBounds = true
    }
    
   
    
}
