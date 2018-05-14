//
//  MeetingParamsList.swift
//  MMSApp
//
//  Created by user on 11/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

class MeetingParamList: NSObject
{
  static var ParamListShareInst = MeetingParamList()
    
    var m_subject: String!
    var m_type: String!
    var r_id: String?
    var m_date: String!
    var m_day: String!
    var m_start_time: String!
    var m_end_time: String!
    var m_with: String!
    var m_location: String!
    var m_all_day_event: String!
    var g_id: String!
    var m_other_user: String!
    var m_invited_by: String!
    var m_agenda: String!
    var m_reminder_flag: String!
    var re_id: String!
    var m_reoccurrence_flag: String!
    var m_reoccurrence_type: String!
    var m_week_day: String!
    var m_week_no: String!
    var m_end_by_date: String!
    var m_end_after_days: String!
    var l_id: String!
    var logged_in_user_id: String!
    var m_internal_user: String!
    var m_ReaptOnWeek : String!
    
    override init() {
        
 }
    
}



