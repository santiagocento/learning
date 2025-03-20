//
//  NavigationSplitViewExamples.swift
//  HowTos
//
//  Created by Santi on 20/03/2025.
//

import SwiftUI

struct NavigationSplitViewExamples: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    // Usando iPhone pro max en landscape se puede ver en columnas
    // De ahi para arriba (iPad, macOS, etc)
    // no funciona si esta dentro de otro NavigationStack, es medio rari
    // Si no entra el split view, se colapsa a un NavigationStack normal
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Text("SideBar View")
                .navigationTitle("Split View")
                // Manejar el ancho de la barra lateral
                .navigationSplitViewColumnWidth(min: 100, ideal: 120, max: 140)
        } content: {
            Text("Content View")
                .navigationSplitViewColumnWidth(min: 100, ideal: 120, max: 140)
        } detail: {
            // Vista a mostrar al no haber seleccionado nada
            VStack {
                Button("Detail Only") {
                    columnVisibility = .detailOnly
                }
                
                Button("Content and Detail") {
                    columnVisibility = .doubleColumn
                }
                
                Button("Show All") {
                    columnVisibility = .all
                }
            }
        }
        // Default es .automatic, que en iphone por ahora es prominentDetail y en iPad es balanced
        .navigationSplitViewStyle(.balanced)
        // .balanced muestra el detalle a la par que las otras columnas
        // .prominentDetail si tiene alguna columna que no sea detail mostrandose,
        // va a atenuar detail y si tocas en detail se sale todo y queda detail
    }
}

#Preview {
    NavigationSplitViewExamples()
}
