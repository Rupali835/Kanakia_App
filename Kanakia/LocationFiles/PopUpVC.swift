

import UIKit
import Alamofire
import GoogleMaps


protocol LocationMapDelegate: class {
    func sendData(lcUserDict : [String: String])
    func sendDeviceData(lcUserDict : [String: String])
}

class PopUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblNames: UITableView!
    
   
    var userList = [AnyObject]()
    var deviceList = [AnyObject]()
    var locationList = [AnyObject]()
    var TdId : String!
    var msg : String!
    var toast : JYToast!
    weak var delegate : LocationMapDelegate?
    var Tag : Int!
    var m_cUserId: String?
    var date: String!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tblNames.delegate = self
        tblNames.dataSource = self
        tblNames.separatorStyle = .none
        toast = JYToast()
        
        tblNames.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        
        if m_cUserId != nil
        {
            fetchDeviceList(userid: self.m_cUserId!, date: self.date)
        }else{
            Tag = 1
            let popUpHgt = self.userList.count * 70
            self.preferredContentSize = CGSize(width: 320, height: popUpHgt)
            tblNames.reloadData()
        }
    }

    
    func fetchDeviceList(userid : String, date : String)
    {
        let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/get_Device"
        let param : [String : Any] = ["user_id" : userid,
                                      "date" : date]
        Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
            print(resp)
            
            self.deviceList.removeAll(keepingCapacity: false)
            let json = resp.result.value as! NSDictionary
            let devicelist = json["device"] as AnyObject
            self.deviceList = devicelist as! [AnyObject]
            self.Tag = 2
            let popUpHgt = self.deviceList.count * 70
            self.preferredContentSize = CGSize(width: 320, height: popUpHgt)
            self.tblNames.reloadData()
        }
    }
    
  
    
    // MARK : TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if Tag == 1
        {
           return userList.count
        }else{
            return deviceList.count
        }
        
    }
    
    func getData(lcUserId: String?, date: String, lcUserListArr: [AnyObject])
    {
        self.m_cUserId = lcUserId
        self.date = date
        self.userList = lcUserListArr
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblNames.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        if Tag == 1
        {
            let lcdict = userList[indexPath.row]
            cell.lblName?.text = (lcdict["user_name"] as! String)
            designCell(cView: cell.backView)
            return cell
        }else{
            let lcdict = deviceList[indexPath.row]
            cell.lblName?.text = lcdict["td_name"] as? String
            designCell(cView: cell.backView)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if Tag == 1
        {
            let lcdict = userList[indexPath.row]
            delegate?.sendData(lcUserDict: lcdict as! [String : String])
            self.dismiss(animated: true, completion: nil)
        }else
        {
            let lcdict = deviceList[indexPath.row]
            delegate?.sendDeviceData(lcUserDict: lcdict as! [String: String])
            self.dismiss(animated: true, completion: nil)
        }
        
       
    }
    
    func designCell(cView : UIView)
    {
        cView.layer.masksToBounds = false
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cView.layer.shadowRadius = 1
        cView.backgroundColor = UIColor.white
    }
 
}
