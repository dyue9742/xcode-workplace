//
//  General.swift
//  Awesome Meeting
//
//  Created by Yue Dai on 2020-07-25.
//  Copyright © 2020 Yue Dai. All rights reserved.
//

import Foundation

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension DateFormatter {
    static var short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static var shortDate: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .none
        return formatter
    }()
    
    static var shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func stringRelativeToToday(_ today: Date, from date: Date) -> String {
        let dateComponents = Calendar.current.dateComponents(in: .current, from: date)
        let nowComponents = Calendar.current.dateComponents(in: .current, from: today)
        if dateComponents.isSameDay(as: nowComponents) {
            return "today"
        }
        return DateFormatter.short.string(from: date)
    }
}

extension DateComponents {
    func isSameDay(as other: DateComponents) -> Bool {
        return self.year == other.year && self.month == other.month && self.day == other.day
    }
    
    func isFuture(as other: DateComponents) -> Bool {
        return self.year ?? 0 > other.year ?? 0 && self.month ?? 0 > other.month ?? 0 && self.day ?? 0 > other.day ?? 0
    }
    
    func isPast(as other: DateComponents) -> Bool {
        return self.year ?? 0 < other.year ?? 0 && self.month ?? 0 < other.month ?? 0 && self.day ?? 0 < other.day ?? 0
    }
}
