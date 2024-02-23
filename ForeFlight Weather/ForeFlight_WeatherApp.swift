//
//  ForeFlight_WeatherApp.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import SwiftUI

@main
struct ForeFlight_WeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
