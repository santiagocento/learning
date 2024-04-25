//
//  RespondingToEventsView.swift
//  HowTos
//
//  Created by Santiago Cento on 24/04/2024.
//

import SwiftUI

struct RespondingToEventsView: View {
    @State private var simple = false
    
    var body: some View {
        VStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                }
            }
            if simple {
                Text("Eventos")
                    // Detecta si la app se va al background o entra en el foreground
                    // a partir de iOS 17 se requiere que tenga el valor nuevo y el viejo en el closure
                    .onChange(of: Environments.scenePhase) { newPhase, oldPhase  in
                        handlePhases(phase: newPhase)
                    }
                    // Lifecycle Events
                    // onAppear() -> viewDidAppear() / onDisappear() -> viewDidDisappear()
                    .onAppear {
                        print("texto aparece")
                    }
                    .onDisappear {
                        print("texto desaparece")
                    }
                
                // En iPadOS y macOS se pueden agregar atajos de teclado
                Button("Log in") { print("logueando") }
                // Esto hara que usando Cmd+L se ejecute lo del boton
                // No se necesita especificar el Cmd porque SwiftUI lo asume a menos que digamos lo contario
                    .keyboardShortcut("l", modifiers: [.command, .option])
                
                // La otra es usar las built-in keys (Escape, arrows, semantic keys por ej cancelar o enter)
                // Esto va a hacer que al apretar el enter se realice la accion
                Button("Confirm") { print("confirmado") }
                    .keyboardShortcut(.defaultAction)
                
            }
        }
        .padding()
        .overlay() {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        }
        .padding()
        Spacer()
    }
    
    func handlePhases(phase: ScenePhase) {
        if phase == .inactive { // Visible pero el usuario no puede interactuar (ej multi-tasking mode)
            print("inactive")
        } else if phase == .active { // en el foreground y el usuario puede interactuar
            print("active")
        } else if phase == .background { // No Visible
            print("background")
        }
    }
}

private struct Environments {
    @Environment(\.scenePhase) static var scenePhase
}

#Preview {
    RespondingToEventsView()
}
