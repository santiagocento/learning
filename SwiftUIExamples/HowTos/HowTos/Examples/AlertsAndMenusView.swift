//
//  AlertsAndMenusView.swift
//  HowTos
//
//  Created by Santi on 20/03/2025.
//

import SwiftUI
import StoreKit

struct AlertsAndMenusView: View {
    @State private var simple = true
    
    @State private var showAlert = false
    @State private var showOptions = false
    @State private var showRecommended = false
    @State private var selectedShow: TVShow?
    @State private var name = ""
    @State private var colorSelection = "Red"
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]
    
    // .alert puede ser puesto en cualquier vista, no hace falta que esten en el root de la vista
    // o en una misma, puede estar en cualquiera
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                Toggle("Simple", isOn: $simple)
            }
            .gridCellColumns(2)
            if simple {
                Button("Mostrar Alerta") {
                    showAlert = true
                }
                .padding()
                .alert("Mensaje Importante", isPresented: $showAlert) {
                    TextField("Ponele algo", text: $name)
                    Button("Oka", role: .cancel) { }
                } message: {
                    Text("Esto es un mensaje")
                }
                
                Button("Select Ted Lasso") {
                    selectedShow = TVShow(name: "Ted Lasso")
                }
                .padding()
                
                Button("Select Bridgerton") {
                    selectedShow = TVShow(name: "Bridgerton")
                }
                .padding()
                
                Button("Show options") {
                    showOptions = true
                }
                .padding()
                .confirmationDialog("¿Color?", isPresented: $showOptions, titleVisibility: .visible) {
                    Button("Rojo") {
                        
                    }
                    Button("Verde") {
                        
                    }
                    Button("Azul") {
                        
                    }
                }
                
                // Con esto hacemos que si manenemos apretado se despliega el menu
                // click derecho en macOS
                Text("Opciones")
                    .padding()
                    .contextMenu {
                        Button {
                            print("Cambiar idioma")
                        } label: {
                            Label("Cambiar idioma", systemImage: "globe")
                        }
                    }
                
                // Este no hay que mantener apretado
                Menu {
                    Button("Ordenar") { }
                    Button("Ajustar") { }
                    Button("Cancelar") { }
                    Menu("Avanzado") {
                        Button("Ordenar") { }
                        Button("Ajustar") { }
                    }
                } label: {
                    Label("Otras opciones", systemImage: "paperplane")
                }
                // Si se le pone primary action se comporta como el contextMenu
                // } primaryAction: {
                //     print("Accion primaria")
                // }
                
                Button("Mostrar una app recomendada") {
                    showRecommended = true
                }
                .padding()
                .appStoreOverlay(isPresented: $showRecommended) {
                    SKOverlay.AppConfiguration(appIdentifier: "6532580692", position: .bottomRaised)
                }
                
                Picker("Seleccionar color", selection: $colorSelection) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
            Spacer()
        }
        // Se puede pasar un elemento que conforme Identifiable en vez de un bool
        .alert(item: $selectedShow) { show in
            Alert(title: Text(show.name), message: Text("Great choice!"), dismissButton: .cancel())
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        }
        .padding()
    }
}

#Preview {
    AlertsAndMenusView()
}

struct TVShow: Identifiable {
    var id: String { name }
    let name: String
}
