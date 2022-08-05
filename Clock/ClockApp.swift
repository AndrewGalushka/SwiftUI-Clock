//
//  ClockApp.swift
//  Clock
//
//  Created by Andrii Halushka on 05.08.2022.
//

import SwiftUI

@main
struct ClockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TimerObservedObject())
        }
    }
}
