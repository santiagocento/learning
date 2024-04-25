//
//  HowTosApp.swift
//  HowTos
//
//  Created by Santiago Cento on 28/03/2024.
//

import SwiftUI

@main
struct HowTosApp: App {
    // Con esto le decimos que use el AppDelegate que creamos
    // SwiftUI se encarga de crear el delegate y manejar su ciclo de vida
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Correr codigo cuando se lanza la app
    // La app comienza por el struct que conforma el protocolo App
    // El trabajo de ese struct es crear la vista inicial usando WindowGroup comunmente o DocumentGroup o similar
    // El init() del struct es un buen lugar para llamar el codigo que necesitamos que corra cuando se lanza la app
    // Esto corre ANTES que se genere el body
    init() {
        print("se inicializa la app")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
