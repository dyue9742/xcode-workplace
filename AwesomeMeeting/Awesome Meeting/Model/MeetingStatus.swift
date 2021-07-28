//
//  LocalMeet.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-07-30.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct MeetingStatus {
    
    var status: MeetingStatus
}

extension MeetingStatus {

    enum MeetingStatus: String {
        case past = "past"
        case today = "today"
        case coming = "coming"
        case unknown = "N/A"
    }
    
    static func checkStatus(_ date: Date) -> MeetingStatus {
        if Calendar.current.dateComponents(in: .current, from: date).isSameDay(as: Calendar.current.dateComponents(in: .current, from: Date())) {
            return .today
        } else if Calendar.current.dateComponents(in: .current, from: date).isPast(as: Calendar.current.dateComponents(in: .current, from: Date())) {
            return .past
        } else if Calendar.current.dateComponents(in: .current, from: date).isFuture(as: Calendar.current.dateComponents(in: .current, from: Date())) {
            return .coming
        } else {
            return .unknown
        }
    }
}
