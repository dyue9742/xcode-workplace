//
//  HaveMeetings.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct HaveMeetings: View {
    
    @ObservedObject var meeting: Meeting
    
    var body: some View {
        HStack (alignment: .center, spacing: 10, content: {
            VStack (alignment: .leading, spacing: 2, content: {
                Text(topic)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(team)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(date)
                    .font(.footnote)
            })
            .padding(1)
            Spacer(minLength: 0)
            Image(systemName: "pencil.and.outline")
                .font(.headline)
                .foregroundColor(Date() > meeting.date ? Color.green : ColorSet.appPink.opacity(0.7))
        })
    }

    var date: String {
        return "\(DateFormatter.short.string(from: meeting.date))"
    }
    var team: String {
        return meeting.team
    }
    var topic: String {
        return meeting.topic
    }
}
