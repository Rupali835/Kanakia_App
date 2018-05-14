//
//  KraListVc.swift
//  Kanakia SOP
//
//  Created by user on 04/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class KraListVc: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var lblKraMsg: UILabel!
    @IBOutlet weak var AcceptByEmpDate: UILabel!
    @IBOutlet weak var AcceptByMngerDate: UILabel!
    @IBOutlet weak var AcceptByManger: UILabel!
    @IBOutlet weak var AcceptByEmp: UILabel!
 
    @IBOutlet weak var btnAcceptKra: UIButton!
  
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tblKra: UITableView!
    var Up_id : String = ""
    var Msg = [AnyObject]()
    var K_id : String!
    var Kpi_Vc : KPI_ListVc!
    var K_name : String!
    private var toast: JYToast!
    var empFlag : String!
    var MngrFlag : String!
    var LoginUp_id : String = ""
    var dict : NSDictionary!
    var empTime : String!
    var mngrTime : String!
    var MngrName : String!
    var EmpNm : String = ""
    var Check = Bool(true)
    
    func HideControl(bStatus: Bool)
   {
        self.AcceptByEmp.isHidden        = bStatus
        self.AcceptByEmpDate.isHidden    = bStatus
        self.AcceptByManger.isHidden     = bStatus
        self.AcceptByMngerDate.isHidden  = bStatus
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  //       self.navigationController?.navigationBar.barTintColor = UIColor(red:0.61, green:0.16, blue:0.69, alpha:1.0)
         self.lblKraMsg.isHidden = true
        self.HideControl(bStatus: true)
        tblKra.delegate = self
        tblKra.dataSource = self
        self.tblKra.estimatedRowHeight = 80
        self.tblKra.rowHeight = UITableViewAutomaticDimension
        self.tblKra.separatorStyle = .none
        
        tblKra.register(UINib(nibName: "KraCell", bundle: nil), forCellReuseIdentifier: "KraCell")
        
        self.dict = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        LoginUp_id = self.dict["up_id"] as! String
        self.dropShadow(cView: backView)
     
        print("Up_id", Up_id)
      
        initUi()

        
    }

    func dropShadow(cView : UIView) {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.AcceptByEmp.text       = ""
        self.AcceptByEmpDate.text   = ""
        self.AcceptByMngerDate.text = ""
        self.AcceptByManger.text    = ""
        getKraList()
    }
    
    func setEmpName(cNm: String, bStatus: Bool)
    {
        if bStatus
        {
          self.EmpNm = cNm
          self.navigationItem.title = cNm
        }else {
            self.navigationItem.title = ""
        }
    }
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowOpacity = 0.23
        cView.layer.shadowRadius = 4
    }
    
    private func initUi() {
        toast = JYToast()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func getKraList()
    {
       
        
  //      self.btnAcceptKra.isHidden = true
        let KraURL = "http://kanishkagroups.com/sop/pms/index.php/API/getKRA"
        let KraParam = ["up_id" : self.Up_id,
                        "type" : "ios"]
        Alamofire.request(KraURL, method: .post, parameters: KraParam).responseJSON { (dataAchive) in
            print(dataAchive)
            let data = dataAchive.result.value as! [String: AnyObject]
            self.Msg = data["msg"] as! [AnyObject]
            
            self.empTime = data["emp_accepted_timestamp"] as! String
            self.mngrTime = data["manager_accepted_timestamp"] as! String
            self.MngrName = data["manager_name"] as! String
            self.empFlag = data ["emp_accepted_flag"] as! String
            self.MngrFlag = data["manager_accepted_flag"] as! String
            
            if self.Msg.isEmpty == true
            {
                self.btnAcceptKra.isHidden = true
                self.backView.isHidden = true
                self.tblKra.isHidden = true
                self.lblKraMsg.isHidden = false
            }
            
            
            if (self.Up_id != self.LoginUp_id) && (self.empFlag == "0") && (self.MngrFlag == "0")
            {
                self.AcceptByEmp.isHidden = false
                self.AcceptByEmp.text = "Pending KRA acceptance from \(self.EmpNm)"
                self.btnAcceptKra.isHidden = true
                
            }else{
                self.btnAcceptKra.setTitle("I Accept My Kra", for: .normal)
            }
            
            if ((self.MngrFlag == "0") && (self.empFlag == "0") && (self.Up_id == self.LoginUp_id))
            {
                self.btnAcceptKra.isHidden = false
                
            }else if((self.MngrFlag == "0") && (self.empFlag == "1"))
            {
                
                if self.Up_id != self.LoginUp_id
                {
                   self.btnAcceptKra.isHidden = false
                self.btnAcceptKra.setTitle("I Accept His KRA & KPI", for: .normal)
                   self.SetManagerData()
                    
                }else{
                    self.btnAcceptKra.isHidden = true
                    self.setData()
                }
                
                
            }else if ((self.empFlag == "0") && (self.MngrFlag == "1"))
            {
              
                if self.Up_id != self.LoginUp_id
                {
                    self.btnAcceptKra.isHidden = true
                    self.SetManagerData()
                }else{
                    self.btnAcceptKra.isHidden = false
                }
            }else
            if ((self.empFlag == "1") && ( self.MngrFlag == "1"))
            {
                self.btnAcceptKra.isHidden = true
                if (self.Up_id != self.LoginUp_id)
                {
                   self.SetManagerAcceptedData()
                }else{
                  self.SetEmpAcceptedData()
                }
            }
            
            self.tblKra.reloadData()
            
        }
    }
    
    func SetManagerAcceptedData()
    {
        self.HideControl(bStatus: false)
        self.AcceptByEmp.text = "Accepted By \(self.EmpNm)"
        self.AcceptByEmpDate.text! = self.empTime
        self.AcceptByManger.text = "Accepted by You "
        self.AcceptByMngerDate.text = mngrTime
    }
    
    func SetEmpAcceptedData()
    {
        self.HideControl(bStatus: false)
        self.AcceptByEmp.text = "Accepted By You"
        self.AcceptByEmpDate.text = self.empTime
        self.AcceptByManger.text = "Accepted by \(self.MngrName!) "
        
        if self.self.MngrFlag == "0"
        {
            self.AcceptByMngerDate.text = ""
        }else{
            self.AcceptByMngerDate.text =  self.mngrTime
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblKra.dequeueReusableCell(withIdentifier: "KraCell", for: indexPath) as! KraCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
//        self.designCell(cView: cell.backView)
        self.dropShadow(cView: cell.backView)
        let lcDict = self.Msg[indexPath.row]
        cell.lblKraName.text = lcDict["k_name"] as? String
        cell.KraWeitage.text = lcDict["fk_weightage"] as? String
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.Kpi_Vc = self.storyboard?.instantiateViewController(withIdentifier: "KPI_ListVc") as! KPI_ListVc
        
       let lcDict  = self.Msg[indexPath.row]
        self.K_id = lcDict["k_id"] as! String
        self.K_name = lcDict["k_name"] as! String
        self.Kpi_Vc.setId(Kk_id: self.K_id, Up_id: self.Up_id, KName: self.K_name, lcempFlag: self.empFlag, lcMngrFlag: self.MngrFlag)
    
  
        navigationController?.pushViewController(Kpi_Vc, animated: true)
    }
    
    
    @IBAction func I_acceptKra_Click(_ sender: Any)
    {
        
        let alert = UIAlertController(title: "Dynamic PMS", message: "Are you sure you want to Accept KRA and KPI?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            if (self.Up_id != self.LoginUp_id)
             {
                self.AcceptManagerKRA()
                
            }else
             {
               self.AcceptKRAEmp()
             }
            
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
        
    func AcceptManagerKRA()
    {
        print("Up_id, Login_id", self.Up_id,self.LoginUp_id)
    
        let acceptKra = "http://kanishkagroups.com/sop/pms/index.php/API/acceptKRAManager"
    
        let Param : [String: Any] =
    [        "up_id" : self.Up_id,
    "manager_up_id" : self.LoginUp_id
    ]
    
        print(Param)
        Alamofire.request(acceptKra, method: .post, parameters: Param).responseJSON { (addResp) in
        
            print(addResp)
            self.btnAcceptKra.isHidden = true
           self.getKraList()
    }
}
    
    func SetManagerData()
    {
        
        self.HideControl(bStatus: false)
        self.AcceptByEmp.text = "Accepted By \(self.EmpNm)"
        self.AcceptByEmpDate.text! = self.empTime
        self.AcceptByManger.text = "Pending KRA acceptance from Manager "
        self.AcceptByMngerDate.isHidden = true
    }
    
    func AcceptKRAEmp()
    {
            let acceptKra = "http://kanishkagroups.com/sop/pms/index.php/API/acceptKRAEmp"
            
            let addParameter : [String: Any] =
                [        "up_id" : self.Up_id  ]
            print(addParameter)
            Alamofire.request(acceptKra, method: .post, parameters: addParameter).responseJSON { (addResp) in
                print(addResp)
                self.btnAcceptKra.isHidden = true
                self.getKraList()
                
            }
        }

    func setData()
    {
        
        self.HideControl(bStatus: false)
        self.AcceptByEmp.text = "Accepted By You"
        self.AcceptByEmpDate.text = self.empTime
        self.AcceptByManger.text = "Pending KRA acceptance from Manager "
        
        if self.self.MngrFlag == "0"
        {
            self.AcceptByMngerDate.text = ""
        }else{
            self.AcceptByMngerDate.text =  self.mngrTime
        }
    }
    
    
}
    

