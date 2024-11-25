//
//  HandlingState.swift
//  HowTos
//
//  Created by Santiago Gabriel Cento on 15/11/2024.
//

/*
 Property wrappers that are sources of truth
 These create and manage values directly:

     @AppStorage
     @FetchRequest
     @GestureState
     @Namespace
     @NSApplicationDelegateAdaptor
     @Published
     @ScaledMetric
     @SceneStorage
     @State
     @StateObject
     @UIApplicationDelegateAdaptor

 Property wrappers that are not sources of truth
 These get their values from somewhere else:

     @Binding
     @Environment
     @EnvironmentObject
     @FocusedBinding
     @FocusedValue
     @ObservedObject
 */

import SwiftUI

struct HandlingStateView: View {
    
    @State private var simple = true
    
    // @AppStorage reads and writes values from UserDefaults. This owns its data.
    // valor por defecto 0
    // UserDefaults.standard by default pero se puede customizar
    // No es secure storage
    @AppStorage("someKey") var localDeviceStorage: Int = 0
    
    // Value type data owned by a different view
    @Binding var bindingValue: Int
    
    // Read data from the system, such as color scheme, accessibility options, and trait collections
    // You can add your own keys
    @Environment(\.colorScheme) var colorScheme
    
    // Reads a shared object that we placed into the environment
    // This doesn't own its data
    /// PELIGROSO - si no se inserta en el environment, rompe todo
    @EnvironmentObject var environmentObject: EnvironmentObj
    
    // Designed to watch for values in the key window
    // Such as a text field that is currently selected
    // See https://developer.apple.com/documentation/swiftui/focus-cookbook-sample
    // @FocusedBinding var focusedBinding
    // @FocusedValue(\.focusedValue) var focusedValue -> como FocusedBinding pero sin unwrap
    
    // You *can* accomplish the same using a simple @State
    // @GestureState automatically sets your property back to its initial value when the gesture ends
    @GestureState var dragAmount = CGSize.zero
    
    // Se utiliza para crear animaciones de propiedades como posición, tamaño y forma entre 2 vistas diferentes
    // Sirve a modo de contenedor de ids para que no se choquen con otras
    @Namespace var animationNamespace
    @State private var isExpanded = false // requerido para el ejemplo
    
    // Refers to an instance of an external class that conforms to the ObservableObject protocol
    // This does not own its data
    @ObservedObject var observedObject: ObservableObj
    
    // Define numbers that should scale automatically according to the user’s Dynamic Type settings.
    @ScaledMetric var imageSize = 50.0
    
    // Lets us save and restore small amounts of data for state restoration. This owns its data.
    @SceneStorage("text") var sceneStorageText = "sceneStorageText"
    
    var body: some View {
        VStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                }
            }
            .padding(.bottom, 8)
            Divider()
            if simple {
                // MARK: -
                Text(environmentObject.property)
                // MARK: -
                Text("GestureState drag offset: \(String(format: "%.2f", dragAmount.width))")
                    .padding()
                    .offset(dragAmount)
                    .gesture(
                        DragGesture().updating($dragAmount) { value, state, transaction in
                            state = value.translation
                        }
                    )
                // MARK: -
                VStack {
                    if isExpanded {
                        DetailView(isExpanded: $isExpanded, namespace: animationNamespace)
                    } else {
                        ListView(isExpanded: $isExpanded, namespace: animationNamespace)
                    }
                }
                .animation(.bouncy(duration: 0.3, extraBounce: 0.2), value: isExpanded)
                // MARK: -
                Text(observedObject.property)
                
                // MARK: -
                Image(systemName: "cloud.sun.bolt.fill")
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                // MARK: -
                TextEditor(text: $sceneStorageText)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
        .overlay() {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        }
        .padding()
        .animation(.bouncy(duration: 0.3, extraBounce: 0.1), value: isExpanded)
        Spacer()
    }
}

#Preview {
    @Previewable @State var bindingValue = 0
    HandlingStateView(bindingValue: $bindingValue, observedObject: ObservableObj())
        .environmentObject(EnvironmentObj())
}

class EnvironmentObj: ObservableObject {
    var property: String = "EnvironmentObj Property"
}

class ObservableObj: ObservableObject {
    // Attached to properties inside an ObservableObject
    // Tells SwiftUI that it should refresh any views that use this property when it is changed.
    // This owns its data.
    @Published var property: String = "Published Property"
}

struct ListView: View { // Requerido para ejemplo de @Namespace
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Text("Tap the card below!")
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .matchedGeometryEffect(id: "card", in: namespace, properties: [.frame, .position, .size], anchor: .top)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
        }
    }
}

struct DetailView: View { // Requerido para ejemplo de @Namespace
    @Binding var isExpanded: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .matchedGeometryEffect(id: "card", in: namespace, properties: [.frame, .position, .size], anchor: .top)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
        }
    }
}
