
import UIKit
import Firebase
import FirebaseDatabase

protocol FirebaseMapDelegate {
    func sendData(lcUserDict : [String])
    func sendDataForLocation(userId : String, deviceNm : String)
}

class FirebasePopUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tblnamesFromFB: UITableView!
    
    var ref:DatabaseReference! = nil
    var handle : DatabaseHandle!
    var deviceList = [AnyObject]()
    var devicenm : String!
    var userList = [String]()
    var userId : String?
    var Tag : Int!
    var delegate : FirebaseMapDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tblnamesFromFB.delegate = self
        tblnamesFromFB.dataSource = self
        
       tblnamesFromFB.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        if Tag == 2
        {
            self.loadDataFromFirebaseForDevice(usernm: self.userId!)
        }else{
            Tag = 1
            let popUpHgt = self.userList.count * 70
            self.preferredContentSize = CGSize(width: 320, height: popUpHgt)
            tblnamesFromFB.reloadData()
        }
        
        
    }

    func getData(lcUserId: String?, lcUserListArr: [String])
    {
       self.userId = lcUserId
       self.userList = lcUserListArr
    }
    
    func loadDataFromFirebaseForDevice(usernm : String)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if self.userId != ""
        {
            let devicenm = Database.database().reference().child(self.userId!)
            handle = devicenm.observe(.value) { [weak self] (snapshot) in
                guard let handle = self?.handle else { return }
                
                if snapshot.exists()
                {
                    self?.deviceList.removeAll(keepingCapacity: false)
                    for snap in snapshot.children.allObjects
                    {
                        if let snap = snap as? DataSnapshot
                        {
                            let key = snap.key
                            self?.deviceList.append(key as AnyObject)
                            let lat = snap.value
                            
                        }
                    }
                    
                    self?.tblnamesFromFB.reloadData()
                //    self?.ref.removeObserver(withHandle: handle)
                }
                
                let popUpHgt = (self?.deviceList.count)! * 70
                self?.preferredContentSize = CGSize(width: 320, height: popUpHgt)
                
            }
        }
    }
    
    // MARK : TABLE VIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if Tag == 1
        {
            return userList.count
        }else{
            return deviceList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblnamesFromFB.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        
        if Tag == 1{
           
            let lcdict = userList[indexPath.row]
            print(lcdict)
            let name = lcdict as! String
            cell.lblName.text = name
            return cell
            
        }else{
            self.devicenm = self.deviceList[indexPath.row] as! String
       //     self.designCell(cView: cell.backView)
            cell.lblName.text = self.devicenm
            return cell
        }
        
       
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if Tag == 1
        {
            let lcdict = userList[indexPath.row]
            delegate?.sendData(lcUserDict: [lcdict])
            self.dismiss(animated: true, completion: nil)
        }else{
            
            let lcdict = deviceList[indexPath.row]
            delegate?.sendDataForLocation(userId: self.userId!, deviceNm: lcdict as! String)
            self.dismiss(animated: true, completion: nil)

        }
      
    }
    
}
