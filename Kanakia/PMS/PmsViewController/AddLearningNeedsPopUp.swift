//
//  AddLearningNeedsPopUp.swift
//  Kanakia
//
//  Created by Prajakta Bagade on 2/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

protocol CallTrainingApi {
    func GetAddedTrainig()
}

class AddLearningNeedsPopUp: UIViewController
{
    @IBOutlet weak var btnSelectTime: UIButton!
    @IBOutlet weak var txtAddTraining: UITextField!
    @IBOutlet weak var btnSelectTopics: UIButton!
    @IBOutlet weak var btnSelectType: UIButton!
    @IBOutlet weak var learningNeedsView: UIView!
    @IBOutlet var listView: UIView!
    @IBOutlet weak var tblList: UITableView!
    
    let dnSelectType = DropDown()
    let dnSelectTopic = DropDown()
    let dnSelectTime = DropDown()
    
    var TopicsArr  = [AnyObject]()
    var TopicsFilterArr  = [AnyObject]()
    var TimeArr = [AnyObject]()
    var TypeArr = [AnyObject]()
    
    var CategoryNm = String()
    var TopicNm = String()
    var Upid = String()
    var LoginId = String()
    
    var toast = JYToast()
    var popUp = KLCPopup()
    var selectedRow : Int!
    
    var Ltype = String()    // category id
    var LTopic = String()   // topic name
    var Ltime = String()    // time
    var m_delegate : CallTrainingApi!
    
    var addFromQuick = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dnSelectType.anchorView = btnSelectType
        dnSelectTopic.anchorView = btnSelectTopics
        dnSelectTime.anchorView = btnSelectTime
        
        setLayout(btn: [btnSelectTime, btnSelectType, btnSelectTopics])
        self.txtAddTraining.isHidden = true
        getTrainingList()
        
        tblList.delegate = self
        tblList.dataSource = self
        selectedRow = 0
     }
    
    func getId(upid : String, loginid : String)
    {
        self.Upid = upid
        self.LoginId = loginid
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        clearData()
    }
    
    func setLayout(btn : [UIButton])
    {
        for Btn in btn
        {
            Btn.layer.cornerRadius = 5.0
            Btn.layer.borderWidth = 1.0
            Btn.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    func clearData()
    {
        btnSelectType.setTitle("Select Learning Type", for: .normal)
        btnSelectTopics.setTitle("Select Topic", for: .normal)
        btnSelectTime.setTitle("Select Time", for: .normal)
        self.txtAddTraining.isHidden = true
    }
    
    func getTrainingList()
    {
        let listUrl = "http://www.kanishkagroups.com/sop/android/get_learning_topics.php"
        
        Alamofire.request(listUrl, method: .get, parameters: nil).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                
               if let Success = json["success"] as? NSDictionary
               {
                self.TopicsArr = Success["learning_topics"] as! [AnyObject]
                
                self.TypeArr = Success["learning_topic_categories"] as! [AnyObject]
                
                self.TimeArr = Success["learning_topic_timeline"] as! [AnyObject]
              
               let Topicdict = ["learning_topic_category": "1",     "learning_topic_id": "0", "learning_topic_name" : "other"]
                
                  let dict = ["learning_topic_category": "2",     "learning_topic_id": "0", "learning_topic_name" : "other"]
                self.TopicsArr.insert(Topicdict as AnyObject, at: 0)
                self.TopicsArr.insert(dict as AnyObject, at: 0)
             
            }
        
                break
            
            case .failure(_):
                break
            }
        }
        
    }
    
    @IBAction func btnSubmit_onClick(_ sender: Any)
    {
        if validData()
        {
            addTrainurl()
        }
       
    }
    
    func validData() -> Bool
    {
        if Ltype.isEmpty == true{
            self.toast.isShow("Select Learning Needs Type")
            return false
        }
        
        if LTopic.isEmpty == true
        {
            self.toast.isShow("Select Learning Needs Topic")
            return false
            
        }
        
        if LTopic == "other"
        {
            if self.txtAddTraining.text == ""
            {
                self.toast.isShow("Please enter learning text")
                return false
            }
        }
        
        if Ltime.isEmpty == true
        {
            self.toast.isShow("Select Learning Needs Time")
            return false
        }
        return true
    }
    
    func openTblList()
    {
        popUp.contentView = listView
        popUp.maskType = .dimmed
        popUp.shouldDismissOnBackgroundTouch = true
        popUp.shouldDismissOnContentTouch = false
        popUp.showType = .slideInFromRight
        popUp.dismissType = .slideOutToLeft
        popUp.show(atCenter:CGPoint(x:self.view.frame.size.width/2,y:self.view.frame.size.height/2), in: self.view)
        tblList.reloadData()
    }
    
    @IBAction func btnSelectType_onclick(_ sender: Any)
    {
      selectedRow = 1
      openTblList()
    }
    
    @IBAction func btnSelectTopic_onClick(_ sender: Any)
    {
        if selectedRow == 1
        {
            selectedRow = 2
            openTblList()
        }else
        {
             self.toast.isShow("First select Learning Needs Type")
        }
        
    }
    
    @IBAction func btnSelectTime_onClick(_ sender: Any)
    {
       selectedRow = 3
        openTblList()
    }
    
    @IBAction func btnCancel_onClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    func addTrainurl()
    {
        var Tpa_Status : String = ""
        var txtVal = String()
        
        if self.Upid == self.LoginId
        {
            Tpa_Status = "0"
        }else{
            Tpa_Status = "1"
        }

        if txtAddTraining.text != ""
        {
            txtVal = txtAddTraining.text!
        }else
        {
            txtVal = ""
        }
        
        let url = "http://kanishkagroups.com/sop/pms/index.php/API/addTrainingWithTimeline"
            let param : [String: Any] =
                [        "up_id" : self.Upid,
                         "tpt_name" : self.LTopic,
                         "tpt_status" : Tpa_Status,
                         "tpt_added_by" : self.LoginId,
                         "tpt_type" : self.Ltype,
                         "learning_topic_timeline_id" : self.Ltime,
                         "other_tpt_name" : txtVal
            ]
            
            print("Training Parameter =", param )
            Alamofire.request(url, method: .post, parameters: param).responseJSON { (addResp) in
                print(addResp)
               
                switch addResp.result
                {
                case .success(_):
                    let json = addResp.result.value as! NSDictionary
                    let Msg = json["msg"] as! String
                    if Msg == "success"
                    {
                        if self.addFromQuick == false
                        {
                            self.m_delegate.GetAddedTrainig()
                            self.toast.isShow("Learning needs added successfully")
                             self.view.removeFromSuperview()
                        }else
                        {
                            self.toast.isShow("Learning needs sent to employee")
                            self.view.removeFromSuperview()
                        }
                        
                      
                    }
                    break
                    
                case .failure(_):
                    self.toast.isShow("Something went wrong")
                    break
                }
                
            }
   
    }
    
}
extension AddLearningNeedsPopUp : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedRow == 1
        {
            return TypeArr.count
        }else if selectedRow == 2
        {
            return TopicsFilterArr.count
        }else if selectedRow == 3
        {
            return TimeArr.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblList.dequeueReusableCell(withIdentifier: "learningNeedsListCell", for: indexPath) as! learningNeedsListCell
        
        if selectedRow == 1
        {
            let lcdict = self.TypeArr[indexPath.row]
            cell.lblListName.text = (lcdict["learning_topic_category_name"] as! String)
        }
        else if selectedRow == 2
        {
            let lcdict = self.TopicsFilterArr[indexPath.row]
            cell.lblListName.text = (lcdict["learning_topic_name"] as! String)
        }
        else if selectedRow == 3
        {
            let lcdict = self.TimeArr[indexPath.row]
            cell.lblListName.text = (lcdict["learning_topic_timeline_name"] as! String)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectedRow == 1
        {
            let lcdict = self.TypeArr[indexPath.row]
         
           self.Ltype = lcdict["learning_topic_category_id"] as! String
            
          self.TopicsFilterArr.removeAll(keepingCapacity: false)
            
            if self.TopicsArr.count > 0
            {
                self.TopicsArr.forEach { lcTopic in
                    let lcTopicsID = lcTopic["learning_topic_category"] as! String
                    
                    if self.Ltype == lcTopicsID
                    {
                        self.TopicsFilterArr.append(lcTopic)
                    }
                }
             }
          
            btnSelectType.setTitle((lcdict["learning_topic_category_name"] as! String), for: .normal)
        }
        else if selectedRow == 2
        {
            let lcdict = self.TopicsFilterArr[indexPath.row]
            btnSelectTopics.setTitle((lcdict["learning_topic_name"] as! String), for: .normal)
            
             self.LTopic = lcdict["learning_topic_name"] as! String
            if self.LTopic == "other"
            {
                self.txtAddTraining.isHidden = false
            }else
            {
                 self.txtAddTraining.isHidden = true
            }
        }
        else if selectedRow == 3
        {
            let lcdict = self.TimeArr[indexPath.row]
            btnSelectTime.setTitle((lcdict["learning_topic_timeline_name"] as! String), for: .normal)
            self.Ltime = lcdict["learning_topic_timeline_id"] as! String
        }
        
        popUp.dismiss(true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
