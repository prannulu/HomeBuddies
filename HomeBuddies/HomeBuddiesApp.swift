//
//  HomeBuddiesApp.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 1/23/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

@main
struct HomeBuddiesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
               LaunchPageView()
            }
        }
    }
    init() {
        FirebaseApp.configure()
    }
}
