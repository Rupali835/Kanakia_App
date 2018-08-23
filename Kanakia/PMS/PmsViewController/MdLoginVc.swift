//
//  MdLoginVc.swift
//  Kanakia SOP
//
//  Created by user on 13/04/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class MdLoginVc: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, ModalControllerDelegate,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive = Bool(false)
    var filtered = NSArray()
    var DataArr = NSArray()
    var Up_id: String!
    var Msg = [AnyObject]()
   
    
    private var toast: JYToast!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)

       tblSearch.delegate = self
       tblSearch.dataSource = self
       searchBar.delegate = self
     //  self.tblSearch.isHidden = true
        tblSearch.separatorStyle = .none
        
         self.tblSearch.register(UINib(nibName: "teamCell", bundle: nil), forCellReuseIdentifier: "teamCell")
        getAllUserMd()
        initUi()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTrainingMdVc.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }

    private func initUi() {
        toast = JYToast()
    }
    
    @objc func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func designCell(cView : UIView)
    {
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
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        let predicate = NSPredicate(format: "user_name CONTAINS  %@", searchText)
        
        self.filtered = self.DataArr.filter { predicate.evaluate(with: $0) } as NSArray
        
        print("names = ,\(self.filtered)")
        if(filtered.count == 0)
        {
            searchActive = false
          
        } else {
            searchActive = true
           
        }
        self.tblSearch.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchActive
        {
            return self.filtered.count
        }
        
        return self.Msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tblSearch.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! teamCell
     
        var lcDict: [String: AnyObject]!
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        self.designCell(cView: cell.backView)
        
      if searchActive
      {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
      }
      else
      {
            lcDict = self.Msg[indexPath.row] as! [String: AnyObject]
      }
        cell.lblEmpName.text = lcDict["user_name"] as? String
        let lcUserName = lcDict["user_name"] as! String
        let firstLetter =  lcUserName.first!
        cell.lblFirstLetter.text = String(describing: firstLetter)
        cell.lblFirstLetter.backgroundColor = getRandomColor()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         var lcDict: [String: AnyObject]!
        
        if searchActive
        {
            lcDict = self.filtered[indexPath.row] as! [String: AnyObject]
             self.searchBar.text = lcDict["user_name"] as? String
        }else{
            lcDict = self.Msg[indexPath.row] as! [String: AnyObject]
        }
        self.Up_id = lcDict["up_id"] as? String
        print("User_id:", self.Up_id)
      
        let Fvc = AppStoryboard.Pms.instance.instantiateViewController(withIdentifier: "Kra_FeedbackVc") as! Kra_FeedbackVc
        Fvc.setupData(cId: self.Up_id)
        navigationController?.pushViewController(Fvc, animated: true)
    }

}
