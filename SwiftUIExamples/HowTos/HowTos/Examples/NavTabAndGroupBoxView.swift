//
//  NavTabAndGroupBoxView.swift
//  HowTos
//
//  Created by Santi on 19/03/2025.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct NavTabAndGroupBoxView: View {
    @State private var simple = false
    @State private var tabview = false
    @State private var groupBox = true
    
    @State private var selectedView: Int = 1
    @State private var revealDetails: Bool = false
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Toggle("Simple", isOn: $simple)
                    Toggle("TabView", isOn: $tabview)
                    Toggle("GroupBox", isOn: $groupBox)
                }
                .gridCellColumns(2)
                if simple {
                    Text("Sin statusbar")
                        .statusBarHidden()
                    List {
                        Text("Wi-Fi")
                            .badge("LAN Solo")

                        Text("Bluetooth")
                            .badge("On")
                    }
                    .scrollContentBackground(.hidden)
                    ScrollView {
                        // Boton de informacion desplegable
                        DisclosureGroup("Show Terms", isExpanded: $revealDetails) {
                            Text("Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here. Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here. Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here. Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here. Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here. Long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here long terms and conditions here.")
                        }
                        // Workaround para saber el offset de scroll de scrollview y accionar
                        // en base al valor
                        // Se usa una preference key para acceder a algun valor de un child
                        // desde su ancestro
                        .background(
                            GeometryReader {
                                Color.clear.preference(key: ViewOffsetKey.self,
                                                       value: -$0.frame(in: .named("scroll")).origin.y)
                            })
                        .onPreferenceChange(ViewOffsetKey.self) {
                            if $0 > 50 {
                                withAnimation {
                                    revealDetails = true
                                }
                            } else if $0 < -50 {
                                withAnimation {
                                    revealDetails = false
                                }
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                }
                
                if tabview {
                    TabView(selection: $selectedView) {
                        Button("Show Second View") {
                            selectedView = 2
                        }
                        .padding()
                        .badge(5)
                        .tabItem {
                            Label("First", systemImage: "1.circle")
                        }
                        .tag(1)
                        
                        Button("Show First View") {
                            selectedView = 1
                        }
                        .padding()
                        .tabItem {
                            Label("Second", systemImage: "2.circle")
                        }
                        .tag(2)
                    }
                    // Paginas scrolleables
                    TabView {
                        Text("First")
                        Text("Second")
                        Text("Third")
                        Text("Fourth")
                    }
                    .background(.black)
                    .foregroundStyle(.white)
                    // Sin puntitos de indicadores
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    // Con puntitos
                    //.tabViewStyle(.page)
                    
                    // Muestra el fondo de los puntitos
                    // .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
                if groupBox {
                    ScrollView {
                        // Sin alignment
                        GroupBox {
                            Text("Your account")
                                .font(.headline)
                            Text("Username: tswift89")
                            Text("City: Nashville")
                        }
                        // Usar VStack para alinear
                        GroupBox {
                            VStack(alignment: .leading) {
                                Text("Your account")
                                    .font(.headline)
                                Text("Username: tswift89")
                                Text("City: Nashville")
                            }
                        }
                        
                        GroupBox {
                            Text("Outer Content")
                            
                            GroupBox {
                                Text("Middle Content")
                                
                                GroupBox {
                                    Text("Inner Content")
                                }
                            }
                        }
                        // Se ve bien en macOS pero no en iOS
                        GroupBox("Your account") {
                            VStack(alignment: .leading) {
                                Text("Username: tswift89")
                                Text("City: Nashville")
                            }
                        }
                    }
                    // Ocultar las toolbar cuando no se quieren
                    .toolbar(.hidden)
                    .toolbar(.hidden, for: .bottomBar)
                }
                Spacer()
            }
            .navigationTitle("Containers")
            .toolbar {
                // boton al final de la vista
                // Usar ToolbarItemGroup si es mas de un boton
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Press Me") {
                        print("Pressed")
                    }
                    Button("Otro Press Me") {
                        print("Pressed")
                    }
                }
            }
            .toolbar {
                ToolbarItem(id: "settings", placement: .primaryAction) {
                    Button("Settings") { }
                }
                // Si no pones una primary action o otra action las secondary no se muestran
                ToolbarItem(id: "help", placement: .secondaryAction) {
                    Button("Help") { }
                }
                // another customizable button
                ToolbarItem(id: "email", placement: .secondaryAction) {
                    Button("Email Me") { }
                }
                
                // a third customizable button, but this one won't be in the toolbar by default
                ToolbarItem(id: "credits", placement: .secondaryAction, showsByDefault: false) {
                    Button("Credits") { }
                }
                ToolbarItem(id: "font", placement: .secondaryAction) {
                    ControlGroup {
                        Button {
                            // decrease font
                        } label: {
                            Label("Decrease font size", systemImage: "textformat.size.smaller")
                        }
                        
                        Button {
                            // increase font
                        } label: {
                            Label("Increase font size", systemImage: "textformat.size.larger")
                        }
                    } label: {
                        Label("Font Size", systemImage: "textformat.size")
                    }
                }
            }
            .toolbarRole(.editor)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        NavTabAndGroupBoxView()
    }
}
