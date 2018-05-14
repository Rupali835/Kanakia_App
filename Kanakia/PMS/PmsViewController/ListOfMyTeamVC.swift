//
//  ListOfMyTeamVC.swift
//  Pms App
//
//  Created by user on 14/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class ListOfMyTeamVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var Mytbl: UITableView!
    
    var Up_id : String = ""
    var empData = [AnyObject]()
    private var toast: JYToast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.navigationController?.navigationBar.barTintColor = UIColor(red:0.61, green:0.16, blue:0.69, alpha:1.0)
        let dict  = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        self.Up_id = dict["up_id"] as! String
        
        Mytbl.dataSource = self
        Mytbl.delegate = self
        getEmpList()
        initUi()
        self.Mytbl.separatorStyle = .none
        
        // Do any additional setup after loading the view.
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
    
    func getEmpList()
    {
        let empUrl = "http://kanishkagroups.com/sop/pms/index.php/API/getMyTeam"
        let empParam : [String: AnyObject] =
            [   "up_id" : self.Up_id as AnyObject,
                "type" : "ios" as AnyObject   ]
        
        Alamofire.request(empUrl, method: .post, parameters: empParam).responseJSON { (EmpResp) in
            print(EmpResp)
            let data = EmpResp.result.value as! [String: AnyObject]
            self.empData = data["msg"] as! [AnyObject]
            print("empData", self.empData)
           
            if self.empData.count == 0
            {
                self.toast.isShow("No any team members found")
            }
             self.Mytbl.reloadData()
            
        }
    }
    
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! employeeCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        
        let lcName = self.empData[indexPath.row]
        let lcUserName = lcName["user_name"] as! String
        let firstLetter = lcUserName.first!
        
        cell.LblEmpName.text = (lcName["user_name"] as! String)
        cell.LblFirstLetter.text = String(describing: firstLetter)
        cell.LblFirstLetter.backgroundColor = getRandomColor()
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var checkNm = Bool(true)
        
        let lcEmpData = self.empData[indexPath.row]
        let lcId = lcEmpData["up_id"] as! String
        let lcName = lcEmpData["user_name"] as? String
        
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "Kra_FeedbackVc") as! Kra_FeedbackVc
        Fvc.setEmpName(cNm: (lcName)!)
        Fvc.setupData(cId: lcId)
        Fvc.Check = checkNm
        navigationController?.pushViewController(Fvc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    
    
    ////// **********************  ////////////////////////
    
}

   
        
    
        

    



