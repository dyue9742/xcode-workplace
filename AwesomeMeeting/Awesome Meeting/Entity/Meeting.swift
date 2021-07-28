//
//  Meeting.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-07-10.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import CoreData

extension Meeting {
    var date: Date {
        get { date_! }
        set { date_ = newValue }
    }
    
    var muid: UUID {
        get { muid_! }
        set { muid_ = newValue}
    }
    
    var team: String {
        get { team_ ?? "N/A" }
        set { team_ = newValue }
    }
    
    var topic: String {
        get { topic_ ?? "N/A" }
        set { topic_ = newValue }
    }
    
    var transcript: String {
        get { transcript_ ?? "N/A" }
        set { transcript_ = newValue }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Meeting> {
        let request = NSFetchRequest<Meeting>(entityName: "Meeting")
        request.sortDescriptors = [NSSortDescriptor(key: "date_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func updateTranscript(needRevise: Meeting, newTranscript: String, context: NSManagedObjectContext) {
        let request = fetchRequest(NSPredicate(format: "muid_ = %@", needRevise.muid as CVarArg))
        let results = (try? context.fetch(request)) ?? []
        print(results)
        if results.isEmpty {
            return
        } else {
            let meeting = results.first
            meeting?.transcript = newTranscript
            print(meeting?.transcript ?? "")
            try? context.save()
        }
    }
}
