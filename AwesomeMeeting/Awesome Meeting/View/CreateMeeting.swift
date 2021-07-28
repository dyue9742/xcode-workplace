//
//  CreateMeeting.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct CreateMeeting: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var beToCreate: Bool
    @State private var emptyInput: Bool = false
    @State private var date: Date = Date()
    @State private var team: String = ""
    @State private var topic: String = ""

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle.init(cornerRadius: 20)
                    .frame(width: UIScreen.main.bounds.width, height: 40, alignment: .center)
                    .cornerRadius(25)
                    .foregroundColor(Color.white)
                HStack {
                    Text("Team")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer(minLength: 0)
                    TextField("Please Enter Your Team Name", text: $team)
                        .frame(width: UIScreen.main.bounds.size.width/1.5)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(10)
            }
            .shadow(color: ColorSet.appPink.opacity(0.3), radius: 1, x: 1, y: 1)
            .shadow(color: Color.white.opacity(0.7), radius: 1, x: -1, y: -1)

            ZStack {
                RoundedRectangle.init(cornerRadius: 20)
                    .frame(width: UIScreen.main.bounds.width, height: 40, alignment: .center)
                    .foregroundColor(Color.white)
                HStack {
                    Text("Topic")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer(minLength: 0)
                    TextField("Please Enter Your Topic", text: $topic)
                        .frame(width: UIScreen.main.bounds.size.width/1.5)
                        .autocapitalization(.none)
                        .lineLimit(1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(10)
            }
            .shadow(color: ColorSet.appPink.opacity(0.3), radius: 1, x: 1, y: 1)
            .shadow(color: Color.white.opacity(0.7), radius: 1, x: -1, y: -1)

            ZStack {
                RoundedRectangle.init(cornerRadius: 20)
                    .frame(width: UIScreen.main.bounds.width, height: 200, alignment: .center)
                    .foregroundColor(Color.white)
                Section (content: {
                    DatePicker("Time", selection: $date, in: Date()...)
                        .labelsHidden()
                })
                .padding(.horizontal)
            }
            .shadow(color: ColorSet.appPink.opacity(0.3), radius: 1, x: 1, y: 1)
            .shadow(color: Color.white.opacity(0.7), radius: 1, x: -1, y: -1)

            Spacer()
            
            HStack {
                Button (action: {
                    self.beToCreate = false
                    self.team = ""
                    self.topic = ""
                }, label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/12)
                        .background(ColorSet.appPink)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                })
                .padding()
                Button (action: {
                    if self.topic.count > 0 {
                        let meeting = Meeting(context: self.managedObjectContext)
                        meeting.muid = UUID()
                        meeting.date = self.date
                        meeting.team = self.team
                        meeting.topic = self.topic
                        meeting.transcript = ""
                        try? self.managedObjectContext.save()
                        self.beToCreate = false
                        self.team = ""
                        self.topic = ""
                    } else {
                        self.emptyInput = true
                    }
                }, label: {
                    Text("Save")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/12)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                })
                .alert(isPresented: $emptyInput, content: {
                    .init(title: Text("Empty Input"), message: Text("Please Input Correctly"), dismissButton: .cancel(Text("okay")))
                })
                .padding()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .edgesIgnoringSafeArea(.all)
        .padding()
    }
}
