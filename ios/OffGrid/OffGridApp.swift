//
//  OffGridApp.swift
//  OffGrid
//
//  Created by Rork on June 8, 2026.
//

import SwiftUI
import SwiftData

@main
struct OffGridApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            OffGridUser.self,
            SocialKey.self,
            RestrictionGoal.self,
            AvatarProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
