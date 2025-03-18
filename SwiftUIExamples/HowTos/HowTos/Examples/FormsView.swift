//
//  FormsView.swift
//  HowTos
//
//  Created by Santi on 17/03/2025.
//

import SwiftUI

struct FormsView: View {
    @State private var simple = true
    
    @State private var showingAdvancedOptions = false
    @State private var enableLogging = false
    @State private var brightness = 0.3
    @State private var selectedColor = "Red"
    @State private var colors = ["Red", "Green", "Blue"]
    
    @State private var selectedStrength = "Mild"
    let strengths = ["Mild", "Medium", "Mature"]
    
    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Toggle("Simple", isOn: $simple)
                }
                .gridCellColumns(2)
                if simple {
                    // Funciona como un VStack cualquiera, solo añade comportamiento
                    // a algunos controles si estan dentro de un form
                    // Usar Group si es mayor a 10 inputs
                    Form {
                        Section(footer: Text("Note: Enabling logging may slow down the app")) {
                            Picker("Select a color", selection: $selectedColor) {
                                ForEach(colors, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.segmented)
                            
                            // Con animacion incluida
                            Toggle("Show advanced options", isOn: $showingAdvancedOptions.animation())
                            
                            if showingAdvancedOptions {
                                Toggle("Enable logging", isOn: $enableLogging)
                            }
                        }
                        
                        Section {
                            Picker("Strength", selection: $selectedStrength) {
                                ForEach(strengths, id: \.self) {
                                    Text($0)
                                }
                            }
                            // Si queres desactivar el comportamiento por defecto
                            //.pickerStyle(.wheel)
                        }
                        
                        Section {
                            // Similar a usar el modifier .badge()
                            // pero en value puede ir cualquier cosa
                            LabeledContent("This is important") {
                                Image(systemName: "exclamationmark.triangle")
                            }
                            
                            // Se puede usar con controles que normalmente no tendrian label como slider
                            LabeledContent {
                                Slider(value: $brightness)
                            } label: {
                                Text("Brightness")
                            }
                            
                            // Soporta hasta 4 textos, cada uno mostrado mas chico que el otro
                            LabeledContent {
                                Text("Value")
                            } label: {
                                Text("Titulo")
                                Text("Subtitulo")
                                Text("Subsubtitulo")
                                Text("Subsubsubtitulo")
                            }
                            
                            Button("Save changes") {
                                // activate theme!
                            }
                            .disabled(enableLogging == false)
                        }
                    }
                }
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 2)
            }
            .padding()
        }
    }
}

#Preview {
    FormsView()
}
