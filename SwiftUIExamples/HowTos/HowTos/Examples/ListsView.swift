//
//  ListsView.swift
//  HowTos
//
//  Created by Santi on 29/11/2024.
//

import SwiftUI

enum SearchScope: String, CaseIterable {
    case inbox, favorites
}

struct ListsView: View {
    @State private var simple = true
    @State private var expandingLists = false
    @State private var scrollToId = false
    @State private var others = false
    
    @State var pizzerias: [String] = ["Pizza Hut", "Pizzeria Uno", "Pizzeria Dos"]
    let items: [Bookmark] = [.example1, .example2, .example3]
    @State private var selection = Set<Int>()
    @State private var searchText: String = ""
    @State private var searchScope = SearchScope.inbox
    
    @State private var users = [
        ListUser(name: "Taylor"),
        ListUser(name: "Justin"),
        ListUser(name: "Adele")
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Toggle("Simple", isOn: $simple)
                    Toggle("Expanding Lists", isOn: $expandingLists)
                    Toggle("Scroll to specific row", isOn: $scrollToId)
                    Toggle("Others", isOn: $others)
                }
                .gridCellColumns(2)
                if simple {
                    // Lista dinamica con accion de mover y borrar
                    // MARK: MOVER EN PREVIEW ANDA COMO EL ORTO
                    List {
                        Section(header: Text("Esto es una sección"), footer: Text("Footer")) {
                            ForEach($pizzerias, id: \.self, editActions: .all) { pizzeria in
                                Pizzeria(name: pizzeria.wrappedValue)
                            }
                            .onDelete(perform: onDelete)
                            .onMove(perform: onMove)
                        }
                        .headerProminence(.increased)
                        .listRowBackground(Color.red)
                    }
                    // Si se hace custom no funciona
                    .deleteDisabled(pizzerias.count < 2)
                    // INSET GROUPED Por defecto
                    .listStyle(.insetGrouped)
                    .toolbar {
                        EditButton()
                    }
                    ExampleGroupedListView()
                    // Usar el edit button para seleccion multiple
                    List(0...15, id: \.self, selection: $selection) { i in
                        Text("\(i)")
                        // Sacar linea divisoria
                            .listRowSeparator(.hidden)
                    }
                }
                if expandingLists {
                    // Usamos children: para hacer listas desplegables
                    List(items, children: \.items) { row in
                        Image(systemName: row.icon)
                        Text(row.name)
                    }
                }
                if scrollToId {
                    ScrollViewReader { proxy in
                        Button("Saltar al 50") {
                            withAnimation {
                                // Anchor .top va a scrollear hasta el elemento 50 y dejarlo al principio, .bottom al final
                                proxy.scrollTo(50, anchor: .bottom)
                            }
                        }
                        List(0..<100, id: \.self) { i in
                            Text("Example \(i)")
                                .id(i)
                        }
                    }
                }
                if others {
                    NavigationStack {
                        Text("Searching for \(searchText)")
                            .navigationTitle("Searchable Example")
                        
                        List {
                            ForEach(searchResults, id: \.self) { name in
                                Text(name)
                                // Custom swipe action button
                                // color por defecto gris
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button("Grapes!") {
                                            print("Right on!")
                                        }
                                        .tint(.purple)
                                    }
                            }
                        }
                        // pull to refresh
                        // ya funciona como un .task { }
                        .refreshable {
                            print("Do your refresh work here")
                        }
                        .searchable(text: $searchText, prompt: "Look for something") {
                            ForEach(searchResults, id: \.self) { result in
                                Text("Are you looking for \(result)?").searchCompletion(result)
                            }
                        }
                        .searchScopes($searchScope) {
                            ForEach(SearchScope.allCases, id: \.self) { scope in
                                Text(scope.rawValue.capitalized)
                            }
                        }
                        .onAppear(perform: runSearch)
                        .onSubmit(of: .search, runSearch)
                        .onChange(of: searchScope) { _, _ in runSearch() }
                    }
                    
                    // MARK: List with bindings
                    List($users) { $user in
                        // En el libro dice que el HStack se genera solo cuando
                        // estas adentro de una lista pero por algun motivo
                        // (capaz porque esta dentro de otras vistas)
                        // no se aplica automaticamente o sea que todo chamuyo
                        HStack {
                            Text(user.name)
                            Spacer()
                            Toggle("User has been contacted", isOn: $user.isContacted)
                                .labelsHidden()
                        }
                    }
                    // Divisor con espaciado, puede ser desde izq o der
                    List(0..<10, id: \.self) { i in
                        Label("Row \(i)", systemImage: "\(i).circle")
                            .alignmentGuide(.listRowSeparatorLeading) { _ in
                                    100
                            }
                            .listItemTint(i.isMultiple(of: 2) ? .red : .green)
                    }
                }
            }
            .padding()
            .overlay() {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 2)
            }
            .padding()
            .onChange(of: selection) { _,_ in
                print(selection)
            }
            
            Spacer()
        }
    }
    func runSearch() {
        //        Task {
        //            guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else { return }
        //
        //            let (data, _) = try await URLSession.shared.data(from: url)
        //            messages = try JSONDecoder().decode([Message].self, from: data)
        //        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return pizzerias
        } else {
            return pizzerias.filter { $0.contains(searchText) }
        }
    }
    
    func onDelete(at offsets: IndexSet) {
        print ("Delete")
        pizzerias.remove(atOffsets: offsets)
    }
    
    func onMove(from source: IndexSet, to destination: Int) {
        print ("Move")
        pizzerias.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    ListsView()
}

struct Pizzeria: View {
    let name: String
    
    var body: some View {
        Text("Restaurant: \(name)")
    }
}

struct ExampleRow: View {
    var body: some View {
        Text("Example Row")
    }
}

struct ExampleGroupedListView: View {
    var body: some View {
        List {
            Section(header: Text("Examples")) {
                ExampleRow()
                ExampleRow()
                ExampleRow()
            }
            // color a linea divisoria
            .listRowSeparatorTint(.red)
        }
        .listStyle(.grouped)
    }
}

struct Bookmark: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var items: [Bookmark]?
    
    // some example websites
    static let apple = Bookmark(name: "Apple", icon: "1.circle")
    static let bbc = Bookmark(name: "BBC", icon: "square.and.pencil")
    static let swift = Bookmark(name: "Swift", icon: "bolt.fill")
    static let twitter = Bookmark(name: "Twitter", icon: "mic")
    
    // some example groups
    static let example1 = Bookmark(name: "Favorites", icon: "star", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
    static let example2 = Bookmark(name: "Recent", icon: "timer", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
    static let example3 = Bookmark(name: "Recommended", icon: "hand.thumbsup", items: [Bookmark.apple, Bookmark.bbc, Bookmark.swift, Bookmark.twitter])
}

struct ListUser: Identifiable {
    let id = UUID()
    var name: String
    var isContacted = false
}
