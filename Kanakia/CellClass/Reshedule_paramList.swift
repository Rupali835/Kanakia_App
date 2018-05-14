//
//  Reshedule_paramList.swift
//  Kanakia SOP
//
//  Created by user on 21/02/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
class ResheduleParamList: NSObject
{
    static var ParamListShareInst = ResheduleParamList()
    
        var user_id : String!
        var m_subject_edit : String!
        var m_type_edit : String!
        var r_id_edit : String!
        var m_date_edit : String!
        var m_day_edit : String!
        var m_start_time_edit : String!
        var m_end_time_edit  : String!
        var m_with_edit : String!
        var m_location_edit : String!
        var m_all_day_event_edit : String!
        var g_id_edit   : String!
        var m_other_user_edit : String!
        var m_invited_by_edit : String!
        var m_agenda_edit : String!
        var m_reminder_flag_edit : String!
        var re_id_edit : String!
        var l_id_edit : String!
        var m_reschedual_flag : String!
        var logged_in_user_id : String!
        var edit_m_id : String!
        var m_internal_user : String!
    
    
    override init() {
        
    }
}
