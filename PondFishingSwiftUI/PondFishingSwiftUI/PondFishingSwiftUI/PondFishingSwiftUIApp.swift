//
//  PondFishingSwiftUIApp.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/11/23.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct PondFishingSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
