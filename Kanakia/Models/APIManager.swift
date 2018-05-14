//
//  APIManager.swift
//  MMSApp
//
//  Created by user on 03/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum ServiceCall: Int
{
    case Default = 0
    case GetMMS
    case GetMeetingDetails
    case Failure
}

class APIManager
{
    private var searchConstant = ServiceCall.Default
    
    func GetMMS()
    {
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        let strUserId = userDict["user_id"] as! String
        
        searchConstant = ServiceCall.GetMMS
       
        let GetMMSUrl = ConstantString.baseURL + ConstantString.getDetailsMMS
  
        let params :[String: String] = ["logged_in_user_id": strUserId, "type": "ios"]
        
        self.callServiceApi(urlString: GetMMSUrl, parameter: params )
    }
    
    func getMeetingDetails(params : [String: String],nGetMeeting : Int)
    {
        searchConstant = ServiceCall.GetMeetingDetails
        var cMeetingURL = ""
        if nGetMeeting == 1
        {
           cMeetingURL = ConstantString.baseURL + ConstantString.getUserMeetingDetails
        }else{
            cMeetingURL = ConstantString.baseURL + ConstantString.getMeetingDetails
        }
        self.callServiceApi(urlString: cMeetingURL, parameter: params)
    }
    
    func callServiceApi(urlString: String, parameter: [String : String])
    {
        Alamofire.request(urlString, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: nil).responseJSON { (resp) in
            //print(resp)

            switch resp.result {
            case .failure( _):
                // Do whatever here
                self.searchConstant = ServiceCall.Failure
                return

            case .success( _):
                
                switch self.searchConstant
                 {
                case .GetMMS: let dict = resp.value as! [String: AnyObject]
                  ModalController.sharedInstance.parseMMSDetail(details: dict)
                case .GetMeetingDetails: let dict = resp.value as! [AnyObject]
                ModalController.sharedInstance.parseMeetingDetails(details: dict)
                case .Failure : ModalController.sharedInstance.Datafailure()
                default:print("default value");
                }
                
            }
       }
    }
    
}

