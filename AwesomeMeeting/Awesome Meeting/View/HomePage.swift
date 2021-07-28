//
//  HomePage.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct HomePage: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var beToCreateOrSearch: Bool = false
    @State private var selection = 0
    @State var enterMeetingDetail: Bool = false

    let operations = ["Create", "Other"]
    
    var body: some View {
        
        Group (content: {
            if beToCreateOrSearch {
                VStack (content: {
                    Picker(selection: $selection, label: Text(""), content: {
                        ForEach(0 ..< operations.count) { index in
                            Text(self.operations[index])
                                .foregroundColor(self.selection == index ? Color.black : Color.clear)
                        }
                    })
                    .labelsHidden()
                    .font(.subheadline)
                    .frame(width: 160, height: 40, alignment: .center)
                    .padding(.top)
                    .pickerStyle(SegmentedPickerStyle())

                    Divider()
                        .padding(5)
                    
                    if self.operations[selection] == "Create" {
                        CreateMeeting(beToCreate: $beToCreateOrSearch).environment(\.managedObjectContext, managedObjectContext)
                    } else if self.operations[selection] == "Other" {
                        OtherOptions(beToSearch: $beToCreateOrSearch).environment(\.managedObjectContext, managedObjectContext)
                    }
                    Spacer()
                })

            } else {
                ZStack (alignment: .bottomTrailing, content: {
                    VStack (alignment: .center, content: {
                        MeetingList(enterMeetingDetail: $enterMeetingDetail).environment(\.managedObjectContext, managedObjectContext)
                        })
                    if !enterMeetingDetail {
                        Button(action: {
                            self.beToCreateOrSearch = true
                        }, label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5)
                                .background(ColorSet.appPink)
                                .foregroundColor(Color.white)
                                .clipShape(Circle())
                                .offset(x: -UIScreen.main.bounds.width/10, y: -UIScreen.main.bounds.height/30)
                        })
                    }
                })
            }
        })
    }
}
