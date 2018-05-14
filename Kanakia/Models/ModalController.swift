//
//  ModalController.swift
//  BookingApp
//
//  Created by ats user on 16/10/17.
//  Copyright © 2017 ats user. All rights reserved.
//

import UIKit
import Alamofire

@objc public protocol ModalControllerDelegate: class {
    
    @objc optional func JsonDetails(details: [String: AnyObject])
    @objc optional func MeetingDetails(Details: [AnyObject])
    @objc optional func remainderDetail(roomsDetails: [reminder])
    @objc optional func labelDetail(roomsDetails: [label])
    @objc optional func groupDetail(grpDetails: [group])
    
    @objc optional func errorReceived(error: String)
   
}

final class ModalController : NSObject
{
    static let sharedInstance = ModalController()
    var room: rooms!
    var reminders : reminder!
    var  cMeetingRoomVc: MeetingRoomVc!
    var cAddMeetingVc: AddMeetingVc!
    var cRescduleMeetingVC: RescduleMeetingVC!
    var cviewController : UIViewController!
    var cHomeVc : HomeVC!
    private override init() {}
    
    public weak var delegate: ModalControllerDelegate?
    
    func errorFromNetwork(_ error: String) {
        delegate?.errorReceived?(error: error)
    }
    
    
    func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    //MARK: - Service Response
    func parseMMSDetail(details: [String: AnyObject])
    {
        self.delegate?.JsonDetails!(details: details)
    }
    
    func parseMeetingDetails(details : [AnyObject])
    {
        self.delegate?.MeetingDetails!(Details: details)
    }
    
    func Datafailure()
    {
        delegate?.errorReceived!(error: "somthing went wrong")
    }

}



//MARK: - Service Response Ends

