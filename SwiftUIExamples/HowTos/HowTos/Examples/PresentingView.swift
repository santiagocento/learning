//
//  PresentingView.swift
//  HowTos
//
//  Created by Santi on 20/03/2025.
//

import SwiftUI
import StoreKit

struct PresentingView: View {
    // Toda vista puede hacer dimiss, no importa como este presentada
    // no funciona el mismo para todas las vistas, tiene que haber 1 por cada vista, como DissmissView1()
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.requestReview) var requestReview
    
    @State private var simple = true
    
    @State private var showSheet: Bool = false
    @State private var showOtherSheet: Bool = false
    @State private var showFullScreen: Bool = false
    @State private var showPopover: Bool = false
    @State private var termsAccepted: Bool = false
    
    let heights = stride(from: 0.2, through: 1.0, by: 0.1).map { PresentationDetent.fraction($0) }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                Toggle("Simple", isOn: $simple)
            }
            .gridCellColumns(2)
            if simple {
                Button("Mostrar Sheet") {
                    showSheet = true
                }
                .padding()
                Button("Mostrar Full Screen") {
                    showFullScreen = true
                }
                .padding()
                
                Button("Mostrar Popover") {
                    showPopover = true
                }
                .padding()
                // En iOS se muestra como un sheet, en iPad como un globo tipo tooltip
                .popover(isPresented: $showPopover) {
                    Text("Contenido del popover")
                        .font(.headline)
                        .padding()
                }
                
                // La facil por defecto, todo funciona
                Button("Pedir review de la app") {
                    requestReview()
                }
                .padding()
            }
            Spacer()
        }
        .sheet(isPresented: $showSheet) {
            Text("Esto es un sheet")
                // Default es .large
                .presentationDetents([.fraction(0.3), .height(300), .medium])
                .presentationCornerRadius(64)
            Button("Otro sheet") {
                showOtherSheet = true
            }
            // Si se ponen 2 .sheet a la misma vista no funciona
            .sheet(isPresented: $showOtherSheet) {
                DismissingView1(terms: $termsAccepted)
                    .presentationCornerRadius(32)
                    .presentationDetents(Set(heights))
                    // Esto hace que no se pueda sacar asi nomas
                    .interactiveDismissDisabled(!termsAccepted)
            }
        }
        // Este no se puede sacar asi nomas y ocupa toda la pantalla
        .fullScreenCover(isPresented: $showFullScreen) {
            Button("Dismiss") {
                showFullScreen.toggle()
            }
            .presentationDetents([.medium])
            .presentationCornerRadius(64)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // hacer fondo transparente
            .presentationBackground(.ultraThinMaterial.opacity(0.90))
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
    PresentingView()
}

struct DismissingView1: View {
    @Environment(\.dismiss) var dismiss
    @Binding var terms: Bool
    var body: some View {
        Toggle("Aceptar Terminos", isOn: $terms)
            .padding(.horizontal)
        Button("Salir") {
            dismiss()
        }
    }
}
