//
//  LinkBoxApp.swift
//  Shared
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

@main
struct LinkBoxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
