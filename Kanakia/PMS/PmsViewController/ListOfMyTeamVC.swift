//
//  ListOfMyTeamVC.swift
//  Pms App
//
//  Created by user on 14/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class ListOfMyTeamVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, didSelectedDelegateEmpCell
{
    
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var Mytbl: UITableView!
    
    var Up_id : String = ""
    var empData = [AnyObject]()
    private var toast: JYToast!
     var filtered = NSArray()
    var searchActive = Bool(false)
    var DataArr = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        let dict  = UserDefaults.standard.value(forKey: "msg") as! NSDictionary
        self.Up_id = dict["up_id"] as! String
        seachBar.delegate = self
        Mytbl.dataSource = self
        Mytbl.delegate = self
        
        getEmpList()
        initUi()
        self.Mytbl.separatorStyle = .none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }

    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
    }
    
    private func initUi() {
        toast = JYToast()
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
        
        let predicate = NSPredicate(format: "user_name CONTAINS[c]  %@", searchText)
        
        self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
        
        print("names = ,\(self.filtered)")
        if(filtered.count == 0)
        {
            searchActive = false
            
        } else {
            searchActive = true
            
        }
        
        self.Mytbl.reloadData()
        
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
            self.DataArr = self.empData.map ({ $0 }) as NSArray
            print(self.DataArr)
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
        
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! employeeCell
        
        var lcDict: [String: AnyObject]!
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        self.designCell(cView: cell.backView)
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
        }else{
            lcDict = self.empData[indexPath.row] as! [String: AnyObject]
        }
        
        let lcUserName = lcDict["user_name"] as! String
        cell.LblEmpName.text = (lcDict["user_name"] as! String)
        
          let firstLetter = lcUserName.first!
        cell.LblFirstLetter.text = String(describing: firstLetter)
        cell.LblFirstLetter.backgroundColor = getRandomColor()
       cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
    func didSelectedRow(cell: employeeCell)
    {
        var lcEmpData: [String: AnyObject]!
        let checkNm = Bool(true)
        
        guard let indexPath = self.Mytbl.indexPath(for: cell) else { return }
        print("SelectedIndex=", indexPath.row)

        if searchActive
        {
            lcEmpData = self.filtered[indexPath.row] as! [String : AnyObject]
        }else{
            lcEmpData = self.empData[indexPath.row] as! [String : AnyObject]
        }
        
      
        let lcId = lcEmpData["up_id"] as! String
        let lcName = lcEmpData["user_name"] as? String
        
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "Kra_FeedbackVc") as! Kra_FeedbackVc
        Fvc.setEmpName(cNm: (lcName)!)
        Fvc.setupData(cId: lcId)
        Fvc.Check = checkNm
        navigationController?.pushViewController(Fvc, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
     
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

   
        
    
        

    



