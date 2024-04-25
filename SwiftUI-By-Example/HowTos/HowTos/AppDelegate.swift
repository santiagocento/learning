//
//  AppDelegate.swift
//  HowTos
//
//  Created by Santiago Cento on 25/04/2024.
//

import UIKit

// En SwiftUI no es necesario tener un AppDelegate pero a veces es conveniente poder usarlo
// capaz para registrar push notifications o responder a warnings de memoria, etc
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // No es necesario implementar este metodo, solo los que necesites
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions")
        return true
    }
}
