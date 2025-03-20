//
//  NavigationExamplesView.swift
//  HowTos
//
//  Created by Santi on 19/03/2025.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        Text("This is the detail view")
    }
}

struct PlayerView: View {
    let name: String
    
    var body: some View {
        Text("Selected player: \(name)")
            .font(.largeTitle)
    }
}

struct NavigationExamplesView: View {
    // Natural approach -> NavigationLink
    // Programmatic control -> NavigationPath
    // Two/Three view layout -> NavigationSplitView
    @State private var simple = false
    @State private var programmatic = false
    @State private var showPathStore = false
    
    @State private var title = "Navigation"
    // Solo sirve si vamos a usar un solo tipo de dato para nuestras vistas
    @State private var presentedNumbers = [1, 4, 8]
    // Type erased wrapper
    @State private var navigationPath = NavigationPath()
    @StateObject private var pathStore: PathStore = PathStore()
    
    @State private var isShowingDetailView = false
    @State private var navigationSelection: String?
    
    let players: [String] = ["Messi", "Ronaldo", "Neymar"]
    
    var body: some View {
        // NavigationStack mapea mas o menos 1 a 1 con UINavigationController
        // se puede pasar a path array de cualquier Hashable para controlar la
        // data que esta en el stack
        // Automaticamente va a arrancar mostrando la vista Has seleccionado la row: 8
        // MARK: NavigationStack(path: $presentedNumbers) {
        // y vamos a poder volver a la 4, despues la 1 y luego al root
        // podemos manipular el stack de vistas segun la data mas que las propias vistas
        // significa que podemos restaurar el estado completo de una app al serializar el navigationPath
        
        NavigationStack(path: $navigationPath) {
            VStack {
                LazyVGrid(columns: [GridItem()]) {
                    Toggle("Simple", isOn: $simple)
                    Toggle("Programmatic", isOn: $programmatic)
                    Toggle("PathStore", isOn: $showPathStore)
                }
                
                if simple {
                    // Dos formas de indicar el destino:
                    // 1- Metiendo el detino dentro del NavigationLink
                    // 2- Usando navigationDestination() (iOS 16+)
                    // usando navigationDestination() las vistas se cargan lazy
                    NavigationLink {
                        // Destino dentro de llaves
                        DetailView()
                    } label: {
                        // label para mayor control sobre que se muestra
                        Label("Go to detail", systemImage: "globe")
                    }
                    // buttonStyle plain para sacar el azul horrible
                    .buttonStyle(.plain)
                    .padding()
                    
                    List(players, id: \.self) { player in
                        // Si NavigationLink comprende todo el contenido dentro de una lista,
                        // toda la row es tappeable
                        NavigationLink(player, value: player)
                        
                        // usando el metodo anterior seria:
                        // ahi estariamos cargando todas las vistas preliminarmente
                        // NavigationLink {
                        //     PlayerView(name: player)
                        // } label: {
                        //     Text(player)
                        // }
                    }
                    .navigationDestination(for: String.self, destination: PlayerView.init)
                    
                    // Se pueden usar diferentes destinos con diferentes valores
                    List {
                        NavigationLink("Mostra un String", value: "Un String")
                        NavigationLink("Mostra un Int", value: 420)
                        NavigationLink("Mostra un Float", value: Float(69.69))
                    }
                    // Para que funcione el de String, hay que sacar el de arriba porque esta duplicado
                    // va a tomar el primer navigationDestination que haya
                    .navigationDestination(for: String.self) { Text("Se recibió un: \($0)") }
                    .navigationDestination(for: Int.self) { Text("Se recibió un: \($0)") }
                    .navigationDestination(for: Float.self) { Text("Se recibió un: \($0)") }
                }
                
                if programmatic {
                    Button("Random") {
                        navigationPath.append(Int.random(in: 1..<50))
                    }
                    List(1..<50) { i in
                        NavigationLink(value: i) {
                            Label("Row \(i)", systemImage: "\(i).circle")
                        }
                    }
                    .navigationDestination(for: Int.self) { index in
                        VStack {
                            Text("Has seleccionado la row: \(index)")
                            Button("Siguiente") {
                                navigationPath.append(index + 1)
                            }
                            Button("pop to root") {
                                navigationPath.removeLast(navigationPath.count)
                            }
                            Button("pop") {
                                navigationPath.removeLast()
                            }
                        }
                    }
                    
                    // Soportar iOS 15 y menos
                    VStack {
                        NavigationLink(destination: Text("NavLink Destination View"),
                                       isActive: $isShowingDetailView) {
                            // Necestiamos pasar una vista igual aunque no la usemos
                            EmptyView()
                        }
                        
                        Button("Mostrar detalle usando NavLink") {
                            // La ventaja es que podemos hacer cualquier cosa antes (validaciones, networking, lo que sea)
                            // viewModel.postDataToBackend(), etc.
                            isShowingDetailView = true
                        }
                        
                        // Si necesitamos manejar mas de un destino
                        NavigationLink(destination: Text("View A"), tag: "A", selection: $navigationSelection) { EmptyView() }
                        NavigationLink(destination: Text("View B"), tag: "B", selection: $navigationSelection) { EmptyView() }
                        
                        Button("Mostrar A") {
                            navigationSelection = "A"
                        }
                        Button("Mostrar B") {
                            navigationSelection = "B"
                        }
                    }
                }
                
                if showPathStore {
                    // En simulador (no preview) si avanzamos en las pantallas, al cerrar y abrir de nuevo la app se va a restaurar el estado
                    NavigationStack(path: $pathStore.path) {
                        NavigationLink("Go to random", value: Double.random(in: 1..<50))
                            .navigationDestination(for: Double.self) {
                                NavigationLink("Double: \($0) >", value: Double.random(in: 1..<50))
                            }
                    }
                }
                Spacer()
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
            .padding()
            // si pasamos un binding, nos deja editar el titulo asi re piola por defecto
            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationExamplesView()
}

// Wrapper para manejar el navigation path y poder guardarlo facilmente
// Mientras que la data que se pase al NavigationPath implemente Codable, va a funcionar
class PathStore: ObservableObject {
    @Published var path = NavigationPath() {
        didSet {
            save()
        }
    }
    
    private let savePath = URL.documentsDirectory.appending(path: "SavedPathStore")
    
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }
    }
    
    func save() {
        guard let representation = path.codable else { return }
        
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}
