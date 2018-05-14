//
//  MMSDetails.swift
//  MMSApp
//
//  Created by user on 03/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

public class rooms: NSObject
{
     var r_Name     : String!
     var r_id       : String!
     var Selected   : Bool!
     var r_tv_flag  : String!
}

public class user : NSObject{
    var user_id : String!
    var user_name : String!
}

public class reminder : NSObject
{
    var re_id  : String!
    var re_name : String!
    var re_selected : Bool!
}

public class Days
{
    var Day_Nm : String!
    var Day_id : String!
    var selected : Bool!
   
    public init(sDayName: String,dayid: String,bselected: Bool)
    {
        self.Day_Nm     = sDayName
        self.Day_id     = dayid
        self.selected   = bselected
    }
   
}

public class label : NSObject
{
    var l_id : String!
    var l_name : String!
}

public class group : NSObject
{
    var g_id: String!
    var g_name: String!
    var selected: Bool!
}

public class InvitedInfo : NSObject
{
    var invitedBy  : String!
    var invitedNm  : String!
    var Start_time : String!
    var End_time   : String!
}

public class MyMeetData : NSObject
{
    var M_subject : String!
    var M_Date : String!
    var M_startTime : String!
    var M_endTime : String!
    
}
class MeetType: NSObject {
    
    var m_Type: String!
    var m_Typeid: String!
}

class MeetWith: NSObject {
    
    var m_With: String!
    var m_Withid: String!
}

//class Friend {
//    var name: String?
//    var pictureUrl: String?
//
//
//}
public class MeetingDetails
{
   var m_subject: String?
   var m_start_time: String?
   var m_end_time: String?
   var r_name: String?
   var m_location: String?
   var r_id : String?
    
    init(json: [String: Any])
    {
        self.m_subject = json["m_subject"] as? String
        self.m_start_time = json["m_start_time"] as? String
        self.m_end_time = json["m_end_time"] as? String
        self.r_name = json["r_name"] as? String
        self.m_location = json["m_location"] as? String
        self.r_id = json["r_id"] as? String
    }
    
}

public class DocumentInfo
{
    var DocumentRemark: String!
    var DocumentMom: String!
    var cFileDocument: [FileDocument]!
}

public class FileDocument
{
    var DocumentImg: String!
    var DocumentName: String!
}


