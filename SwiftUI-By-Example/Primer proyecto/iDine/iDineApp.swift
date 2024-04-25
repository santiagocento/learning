//
//  iDineApp.swift
//  iDine
//
//  Created by Santiago Cento on 09/03/2024.
//

import SwiftUI

@main
struct iDineApp: App {
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(order)
        }
    }
}
