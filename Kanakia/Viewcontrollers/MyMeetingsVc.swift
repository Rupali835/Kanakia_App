//
//  MyMeetingsVc.swift
//  MMSApp
//
//  Created by user on 14/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire


class MyMeetingsVc: UIViewController, UITableViewDelegate, UITableViewDataSource,HeaderViewDelegate
{
   @IBOutlet weak var tblMeeting: UITableView!
    var items = [ProfileViewModelItem]()
    var SortData = [ProfileViewModelItem]()
   
    var resMeetArr : [Any]!
    var resDict1 = [String : Any]()
    var SortedDict: [String : Any]?
    var strUserId:String = ""
    var NumberOfRows : Int!
    var meetingsArr = [MeetingDetails]()
    var convertedArray: [Date] = []
    
    var DataArr = [AnyObject]()
    
     fileprivate let viewModel = ProfileViewModel()
   
    override func viewWillAppear(_ animated: Bool)
    {
        self.NumberOfRows = 0
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tblMeeting.separatorStyle = .none
        self.navigationItem.title = "Seven Days Calendar"
        self.navigationController?.setNavigationBarHidden(false, animated: false)


        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate: String = formatter.string(from: Date())
        let lastDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let sevenday :String = formatter.string(from: lastDate!)
        print(sevenday)
        
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
        
        let parameteres = [ "user_id" : strUserId,
                            "start_date" : stringDate,
                            "end_date" : sevenday
            ] as [String : Any]
        
        self.navigationController?.navigationBar.isHidden = false
        self.tblMeeting.dataSource = self
        self.tblMeeting.delegate = self
        
        self.tblMeeting.register(MyMeetingCell.nib, forCellReuseIdentifier: MyMeetingCell.identifier)
        
     self.tblMeeting?.register(DateHeaderView.nib, forHeaderFooterViewReuseIdentifier: DateHeaderView.identifier)
        
        self.tblMeeting?.estimatedRowHeight = 100
        self.tblMeeting?.rowHeight = UITableViewAutomaticDimension
        self.tblMeeting?.sectionHeaderHeight = 70
        self.tblMeeting?.separatorStyle = .none
        
        let urlString = "http://kanishkagroups.com/sop/android/get_meeting_7_days_ios.php"
        
            
             Alamofire.request(urlString, method: .post, parameters: parameteres).responseJSON { (respnc) in
               
                print(respnc)
                
            let data = respnc.result.value as? [String:Any]
            self.resDict1 = (data!["data"] as? [String : Any])!
            
           let SortedDict = self.resDict1.sorted(by: { $0.0 < $1.0 })
        
            
            for (KeyValue,_) in SortedDict
            {
                print(KeyValue)

                if let meetingsData = self.resDict1[KeyValue] as? [[String: Any]]
                {
                    self.meetingsArr = meetingsData.map { MeetingDetails(json: $0)}

                    let SortedMeetingArr = self.meetingsArr.sorted(by: {$0.m_start_time! < $1.m_start_time! })
                    
                        let meetingsItem = ProfileViewModeFriendsItem(meetings: SortedMeetingArr,cKey: KeyValue)
                   
                       self.items.append(meetingsItem)

                }
            
        }
           
            print(self.items.count)
          
            self.viewModel.reloadSections = { [weak self] (section: Int) in
                self?.tblMeeting?.beginUpdates()
                self?.tblMeeting?.reloadSections([section], with: .automatic)
                self?.tblMeeting?.endUpdates()
            }
            
            
           self.tblMeeting.reloadData()
        
      }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return items.count
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let item = items[section]
        guard item.isCollapsed else {
            return 0
        }
        
        return item.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let item = items[indexPath.section]
       
        switch item.type
        {
        case .MeetingData:
            if let item = item as? ProfileViewModeFriendsItem, let cell = self.tblMeeting.dequeueReusableCell(withIdentifier: "MyMeetingCell", for: indexPath) as? MyMeetingCell
            {
                let meeting = item.MeetingArr[indexPath.row]
                cell.item = meeting
                return cell
            }
        case .MeetingData2:
            print("")
        case .MeetingData3:
            print("")
        case .MeetingData4:
           print("")
        case .MeetingData5:
            print("")
        case .MeetingData6:
            print("")
        case .MeetingData7:
            print("")
        case .MeetingData8:
            print("")
        }
        
        return UITableViewCell()
    }

 
   
    
    func toggleSection(header: DateHeaderView, section: Int)
    {
        var item = items[section]
        
        if item.isCollapsible
        {

            // Toggle collapse
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            self.viewModel.reloadSections!(section)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if let lcDateheaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateHeaderView.identifier) as? DateHeaderView {
            let item = items[section]
           
            
            lcDateheaderView.item = item
            lcDateheaderView.section = section
            lcDateheaderView.delegate = self
            return lcDateheaderView
            
        }
        return UIView()
    }
}

enum ProfileViewModelItemType
{
    case MeetingData
    case MeetingData2
    case MeetingData3
    case MeetingData4
    case MeetingData5
    case MeetingData6
    case MeetingData7
    case MeetingData8
}

protocol ProfileViewModelItem {
    var type: ProfileViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
    var isCollapsible: Bool { get }
    var isCollapsed: Bool { get set }
}

extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible: Bool {
        return true
    }
}

class ProfileViewModel: NSObject
{
    var items = [ProfileViewModelItem]()
    
   var SortData = [ProfileViewModelItem]()
    var reloadSections: ((_ section: Int) -> Void)?
    
    override init()
    {
        super.init()
   
    }
    
    func setData(cMeetingArr: [MeetingDetails])->[ProfileViewModelItem]
    {
        
        if !cMeetingArr.isEmpty
        {
           // let meetingsItem = ProfileViewModeFriendsItem(meetings: cMeetingArr)
           // items.append(meetingsItem)
        }
        
     
        return items
    }
}

class ProfileViewModeFriendsItem: ProfileViewModelItem
{
    
    var type: ProfileViewModelItemType {
        return .MeetingData
    }
    
    var sectionTitle: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let stringDate: String = formatter.string(from: Date())
//        print(stringDate)
        return self.cKeyValue
    }
    
    var rowCount: Int
    {
        return MeetingArr.count
    }
    
    var isCollapsed = true
    
    var MeetingArr : [MeetingDetails]
    var cKeyValue : String!
    
    init(meetings: [MeetingDetails], cKey: String) {
        self.MeetingArr = meetings
        self.cKeyValue = cKey
    }
}




