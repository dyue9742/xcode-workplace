//
//  MeetingList.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct MeetingList: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Meeting.entity(), sortDescriptors: []) var meetings: FetchedResults<Meeting>
    @Binding var enterMeetingDetail: Bool
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(self.meetings, id: \.self, content: { meeting in
                    NavigationLink (destination: MeetingDetail(meeting: meeting).environment(\.managedObjectContext, self.managedObjectContext), isActive: self.$enterMeetingDetail, label: {
                        HaveMeetings(meeting: meeting)
                    })
                })
            }
            .navigationBarTitle(Text("Meetings"))
        }
    }
}
