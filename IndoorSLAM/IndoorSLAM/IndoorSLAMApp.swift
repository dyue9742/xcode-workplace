//
//  IndoorSLAMApp.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-01-23.
//

import SwiftUI

@main
struct IndoorSLAMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
