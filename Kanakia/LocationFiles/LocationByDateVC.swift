

import UIKit
import GoogleMaps
import Alamofire

class LocationByDateVC: UIViewController, UIPopoverPresentationControllerDelegate, LocationMapDelegate
{
    @IBOutlet weak var btnSelectDevice: UIButton!
    @IBOutlet weak var btnSelectUser: UIButton!
    
    @IBOutlet weak var tblDevice: UITableView!
    @IBOutlet weak var tblUser: UITableView!
    @IBOutlet var viewForDevice: UIView!
    @IBOutlet var viewForUser: UIView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewDate: UIView!
   
    
    let datepicker = UIDatePicker()
    let toolBar = UIToolbar()
    var popUp : KLCPopup!
    var DateStr : String?
    var userList = [AnyObject]()
    var deviceList = [AnyObject]()
    var locationList = [AnyObject]()
     private var toast: JYToast!
    var TdId : String!
    var msg : String!
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp = KLCPopup()
        createDatePicker()
        toast = JYToast()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        self.txtDate.text = stringDate
        self.DateStr = stringDate
        mapView.isMyLocationEnabled = true
    }
    
    func createDatePicker()
    {
        _ = Date()
        datepicker.maximumDate = Date()
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
        dateFormatter.dateStyle = .long
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

    // MARK : BUTTON ACTION
    
    @IBAction func btnPicker_OnClick(_ sender: Any)
    {
        createDatePicker()
    }
    
    @IBAction func btnSelectUser_OnClick(_ sender: UIButton)
    {
        self.userId = nil
        self.fetchUserList(date: self.DateStr!, sender: sender)
        btnSelectDevice.setTitle("Select Device", for: .normal)
    }
    
    @IBAction func btnSelectDevice_OnClick(_ sender: UIButton)
    {
        
        if btnSelectUser.titleLabel?.text != "Select User"
        {
            OpenPopUp(sender: sender, tag: 2)
        }else{
            self.toast.isShow("Please select user name")
        }
        
    }
    
    func sendData(lcUserDict : [String: String])
    {
        let name = lcUserDict["user_name"]
        self.userId = lcUserDict["user_id"]
        btnSelectUser.setTitle(name, for: .normal)
    }
    
    func sendDeviceData(lcUserDict : [String: String])
    {
        let lcDevicename = lcUserDict["td_name"]
        self.TdId = lcUserDict["td_id"]
        btnSelectDevice.setTitle(lcDevicename, for: .normal)
        fetchLocation(tdid: self.TdId)
    }
    
    func OpenPopUp(sender : UIButton, tag : Int)
    {
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        popController.delegate = self
        popController.Tag = tag
        
        popController.getData(lcUserId: self.userId, date: DateStr!, lcUserListArr: self.userList)
        
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
       popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender  // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        popController.preferredContentSize = CGSize(width: 300, height: 0)
        self.present(popController, animated: true, completion: nil)
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
   
    func fetchLocation(tdid : String)
    {
         let path =  GMSMutablePath()
            
            let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/get_Location"
            let param : [String : Any] = ["device_id" : tdid,
                                          "date" : self.DateStr!]
            Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
                print(resp)
                
                let json = resp.result.value as! NSDictionary
                
                let msg = json["msg"] as! String
                
                if msg == "success"
                {
                    self.mapView.clear()
                    self.locationList = json["location"] as! [AnyObject]
                    
                    for val in self.locationList
                    {
                        let lat = Double(val["l_lat"] as! String)
                        let long = Double(val["l_long"] as! String)
                        
                        path.addLatitude(lat!, longitude: long!)
                        
                        let polyLine = GMSPolyline(path: path)
                        polyLine.strokeWidth = 6.0
                        polyLine.geodesic = true
                        polyLine.map = self.mapView
                        polyLine.strokeColor = .red
                        
                        let hydeParkLocation = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                        let camera = GMSCameraPosition.camera(withTarget: hydeParkLocation, zoom: 20)
                        self.mapView?.animate(to: camera)
                    }
                    
                  }else if msg == "fail"
                {
                    self.toast.isShow("location not found")
                }
            }
     
    }

    func fetchUserList(date : String, sender: UIButton)
    {
        let url = "http://kanishkagroups.com/sop/liveTrack/index.php/Android/API/get_User"
        
        let param = ["date" : date]
        
        Alamofire.request(url, method: .post, parameters: param).responseJSON { (resp) in
            
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let json = resp.result.value as! NSDictionary
                self.msg = json["msg"] as! String
                
                if self.msg != "success"
                {
                    self.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Live Tracking", message: "No any users for this date", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    self.userList.removeAll(keepingCapacity: false)
                    let userlist = json["user"] as AnyObject
                    self.userList = userlist as! [AnyObject]
                    self.OpenPopUp(sender: sender, tag: 1)
                }
                
                break
                
            case .failure(_):
                self.toast.isShow("Something went wrong")
                break
            }
            
        }
        
    }
    
    
}
