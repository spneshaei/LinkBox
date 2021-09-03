//
//  LinkBoxApp.swift
//  LinkBox Watch WatchKit Extension
//
//  Created by Seyyed Parsa Neshaei on 9/3/21.
//

import SwiftUI

@main
struct LinkBoxApp: App {
    let persistenceController = PersistenceController.shared
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                FoldersView()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.layoutDirection, .rightToLeft)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
