//
//  xiekaApp.swift
//  xieka
//
//  Created by zclee on 2025/12/17.
//

import SwiftUI

@main
struct xiekaApp: App {
    @StateObject private var store = AppStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
                .environmentObject(store)
        }
    }
}
