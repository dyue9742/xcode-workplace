//
//  MeetingDetail.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-08-05.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import SwiftUI
import Speech
import NaturalLanguage

struct MeetingDetail: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var recognitionEnabled: Bool = false
    @State private var showKeyword: Bool = false
    @State private var needToEdit: Bool = false
    @ObservedObject var meeting: Meeting

    let startText = "Start Speech Recognition"
    
    var body: some View {
        Group {
            VStack {
                if recognitionEnabled {
                    SpeechRecognition(recognitionEnabled: $recognitionEnabled, meeting: meeting, speech: .init()).environment(\.managedObjectContext, managedObjectContext)
                } else {
                    if needToEdit {
                        ReviseTranscript(meeting: meeting, needToRevise: $needToEdit).environment(\.managedObjectContext, managedObjectContext)
                    } else {
                        VStack (alignment: .center, spacing: 1, content: {
                            HStack (alignment: .firstTextBaseline, spacing: 3, content: {
                                Text(date)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer(minLength: 0)
                                Text(team)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            })
                                .padding()
                            ZStack (alignment: .top, content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                                    .foregroundColor(Color.white)
                                ScrollView (.vertical, showsIndicators: false, content: {
                                    Text(showKeyword ? keyword : transcript)
                                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                                        .multilineTextAlignment(.leading)
                                })
                                    .padding()
                            })
                                .shadow(color: Color.black.opacity(0.3), radius: 1, x: 5, y: 5)
                                .shadow(color: Color.white.opacity(0.7), radius: 1, x: -5, y: -5)
                            Spacer(minLength: 50)
                            if transcript.isEmpty {
                                Button(action: {
                                    self.recognitionEnabled = true
                                }, label: {
                                    Text(startText)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .frame(width: UIScreen.main.bounds.width/1.6, height: UIScreen.main.bounds.height/12)
                                        .background(ColorSet.appPink)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                })
                            } else {
                                HStack(alignment: .center, spacing: 1, content: {
                                    Spacer(minLength: 0)
                                    Button(action: {
                                        self.needToEdit = true
                                    }, label: {
                                        Text("Edit")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .frame(width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/12)
                                            .background(ColorSet.appPink)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                    })
                                    Spacer(minLength: 0)
                                    Button(action: {
                                        self.recognitionEnabled = true
                                    }, label: {
                                        Text("Re-reco")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .frame(width: UIScreen.main.bounds.width/2.6, height: UIScreen.main.bounds.height/12)
                                            .background(ColorSet.appPink)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                    })
                                    .blur(radius: needToEdit ? 10 : 0)
                                    Spacer(minLength: 0)
                                })
                            }
                            Spacer(minLength: 20)
                        })
                        .padding()
                        .navigationBarTitle(topic)
                        .navigationBarItems(trailing:
                            Button(action: {
                                self.showKeyword = !self.showKeyword
                            }, label: {
                                Image(systemName: "tag")
                                    .font(.headline)
                                    .foregroundColor(ColorSet.appPink)
                            })
                        )
                    }
                }
            }
        }
    }
    
    var date: String {
        return DateFormatter.short.string(from: meeting.date)
    }
    
    var team: String {
        return meeting.team
    }
    
    var topic: String {
        return meeting.topic
    }
    
    var transcript: String {
        return meeting.transcript
    }
        
    var keyword: String {
        return identifyPartsOfSpeechc(transcript)
    }
    
    func identifyPartsOfSpeechc(_ transcript: String) -> String {
        var keyword: String = ""
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = transcript
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.enumerateTags(in: transcript.startIndex..<transcript.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                if "\(tag.rawValue)" == "Noun" {
                    keyword.append("\(transcript[tokenRange]) \n")
                }
            }
            return true
        }
        return keyword
    }
}


struct ReviseTranscript: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var meeting: Meeting
    @Binding var needToRevise: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Spacer(minLength: 0)
            MultilineView(text: $meeting.transcript)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                .background(Color.white)
                .cornerRadius(20)
            HStack(alignment: .center, spacing: 10, content: {
                Spacer(minLength: 0)
                Button(action: {
                    self.needToRevise = false
                }, label: {
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5, alignment: .center)
                        .background(ColorSet.appPink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                Spacer(minLength: 0)
                Button(action: {
                    Meeting.updateTranscript(needRevise: self.meeting, newTranscript: self.meeting.transcript, context: self.managedObjectContext)
                    self.needToRevise = false
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(width: UIScreen.main.bounds.width/5, height: UIScreen.main.bounds.width/5, alignment: .center)
                        .background(ColorSet.appPink)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                })
                Spacer(minLength: 0)
            })
            Spacer(minLength: 0)
        })
        .background(ColorSet.appPurple.opacity(0.1))
        .background(Blur())
        .edgesIgnoringSafeArea(.all)
    }
}


struct SpeechRecognition: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var recognitionEnabled: Bool
    @ObservedObject var meeting: Meeting
    @ObservedObject var speech: Speech
    
    var transcript: String {
        return speech.transcript
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 10, content: {
            Spacer(minLength: 0)
            Text(transcript)
                .font(.caption)
                .fontWeight(.light)
                .background(Color.white)
                .foregroundColor(Color.black.opacity(0.95))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.6)
                .border(ColorSet.appPink, width: 5)
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
                .padding()
            HStack (alignment: .center, spacing: 10, content: {
                Spacer(minLength: 0)
                Button(action: {
                    self.speech.recordButtonTapped()
                    self.recognitionEnabled = false
                }, label: {
                    Text("Cancel")
                        .font(.headline)
                        .fontWeight(.semibold)
                })
                Spacer(minLength: 0)
                Button(action: {
                    if self.transcript != "(Go ahead, I'm listening)" {
                        self.meeting.transcript = self.transcript
                    }
                    try? self.managedObjectContext.save()
                    self.speech.recordButtonTapped()
                    self.recognitionEnabled = false
                }, label: {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.semibold)
                })
                Spacer(minLength: 0)
            })
            .padding()
            Spacer(minLength: 0)
        })
    }
}

struct MultilineView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
