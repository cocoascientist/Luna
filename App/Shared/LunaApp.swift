//
//  LunaApp.swift
//  Shared
//
//  Created by Andrew Shepard on 6/23/20.
//

import SwiftUI
import ContentProvider
import Waypoints

@main
struct LunaApp: App {
    @StateObject private var provider = ContentProvider(
        locationTracker: LocationTracker(),
        session: URLSession.shared
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView(state: provider.state)
        }
    }
}
