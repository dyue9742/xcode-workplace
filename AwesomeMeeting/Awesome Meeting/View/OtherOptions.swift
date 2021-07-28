//
//  OtherOptions.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI

struct OtherOptions: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var beToSearch: Bool
    @State private var wantToSearch: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Keyword")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer(minLength: 0)
                TextField("enter something...", text: $wantToSearch)
                    .frame(width: UIScreen.main.bounds.width/1.5, alignment: .center)
                    .autocapitalization(.none)
                    .lineLimit(1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(10)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }

            GeometryReader { geometry in
                VStack (alignment: .leading, spacing: 10, content: {
                    Button(action: {
                        
                    }, label: {
                        Text("Review")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorSet.appPink)
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ColorSet.appPink, lineWidth: 3))
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("Corporation")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorSet.appPink)
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ColorSet.appPink, lineWidth: 3))
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("Team Chats")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorSet.appPink)
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ColorSet.appPink, lineWidth: 3))
                    })
                    Button(action: {
                        
                    }, label: {
                        Text("Privacy & Setting")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorSet.appPink)
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.1)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(ColorSet.appPink, lineWidth: 3))
                    })
                })
                .padding()
            }
            
            Spacer(minLength: 0)
            
            Button (action: {
                self.beToSearch = false
                self.wantToSearch = ""
            }, label: {
                Text("Cancel")
                .frame(width: UIScreen.main.bounds.width/2.5, height: UIScreen.main.bounds.height/12)
                .background(ColorSet.appPink)
                .foregroundColor(Color.white)
                .cornerRadius(20)
            })
            .padding(.bottom)
        }
    }
}
