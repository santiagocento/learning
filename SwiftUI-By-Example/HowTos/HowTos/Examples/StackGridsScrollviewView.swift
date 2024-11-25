//
//  StackGridsScrollviewView.swift
//  HowTos
//
//  Created by Santiago Cento on 10/04/2024.
//

import SwiftUI

struct StackGridsScrollviewView: View {
    let data = (1...100).map { "Item \($0)"}
    let items = 1...50
    @State private var redScore = 0
    @State private var blueScore = 0
    @State private var username = "Anon"
    @State private var bio = ""
    @State private var users = [
        User(id: 1, name: "Taylor Swift", score: 95),
        User(id: 2, name: "Billie Eilish", score: 80),
        User(id: 3, name: "Olivia Rodrigo", score: 85)
    ]
    @State private var selection: User.ID?
    @State private var sortOrder = [KeyPathComparator(\User.name)]

    @State private var simple = false
    @State private var scrollview = false
    @State private var lazyStacksAndGrids = false
    @State private var lazyGrids = false
    @State private var tableYScrollBehaviour = true
    
    // MARK: Posicionar vistas de manera estructurada
    // Por default, HStack y VStack cargan todo el contenido UP FRONT!
    var body: some View {
        VStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                    Toggle(isOn: $scrollview, label: { Text("Scrollview") })
                    Toggle(isOn: $lazyStacksAndGrids, label: { Text("Lazy Stacks Y Grids") })
                    Toggle(isOn: $lazyGrids, label: { Text("Lazy Grids") })
                    Toggle(isOn: $tableYScrollBehaviour, label: { Text("Table & Scroll Behaviour") })
                }
            }
            .padding(.bottom, 8)
            Divider()
            if simple {
                // Hacer disitincion entre elementos con divider
                // Por default se alinean en el centro
                VStack {
                    Text("Hello")
                    Divider()
                    Text("World")
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hello")
                    Text("World")
                }
                
                // Empujar cosas con Spacer
                HStack {
                    Spacer()
                    Text("Hello World!")
                }
                
                // Empujar cosas con Spacer pero fraccionando
                HStack {
                    Spacer()
                    Spacer()
                    Text("Hello World!")
                    Spacer()
                }
                
                HStack {
                    Spacer()
                        .frame(maxWidth: 30)
                    Text("Hello World!")
                }
                
                // ZStack
                // Lo que se ponga primero va a dibujarse primero, lo siguiente se dibuja por encima
                ZStack(alignment: .center) {
                    Text("World")
                        .offset(x: 30)
                        .background(.cyan)
                        .zIndex(1)
                    HStack {
                        Spacer()
                        Text("Hello")
                    }
                    .background(.red)
                }
                
                // Ejemplo de AdaptiveStack
                // Solo esta andando en iPad
                AdaptiveStack {
                    Text("Horizontal when there's space")
                    Text("but")
                    Text("Vertical when is restricted")
                }
            }
            if scrollview {
                // VERTICAL
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(0..<4) {
                            Text("Item \($0)")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .frame(width: 250, height: 70)
                                .background(.green)
                        }
                    }
                }
                .padding()
                .border(.gray)
                .frame(height: 200)
                Divider()
                // HORIZONTAL
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<4) {
                            Text("Item \($0)")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .frame(width: 250, height: 70)
                                .background(.green)
                        }
                    }
                }
                .padding()
                .border(.gray)
                .frame(height: 100)
                
                // MARK: ScrollViewReader
                // Usar scrollTo() para moverlo solo a una posicion programáticamente
                // Tambien funciona con listas
                ScrollViewReader { value in
                    ScrollView {
                        Button("Jump to #2") {
                            withAnimation {
                                value.scrollTo(2, anchor: .top)
                            }
                        }
                        ForEach(0..<4) { i in
                            Text("Item \(i)")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .frame(width: 250, height: 70)
                                .background(.green)
                                .id(i)
                        }
                    }
                    .padding()
                    .border(.gray)
                    .frame(height: 100)
                }
                
                
                // Efectos 3D con Scrollview y GeometryReader
                // rotation3DEffect()
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(1..<4) { num in
                            VStack {
                                GeometryReader { geo in
                                    Text("Item \(num)")
                                        .padding()
                                        .font(.largeTitle)
                                        .background(.green)
                                        .frame(width: 200, height: 70)
                                        .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).minX) / 8), axis: (x: 0, y: 1, z: 0))
                                        
                                }
                            }
                            .frame(width: 200, height: 70)
                        }
                    }
                }
                .padding()
                .border(.gray)
            }
            if lazyStacksAndGrids {
                // MARK: LazyVStack y LazyHStack
                // Solo crea contenido cuando entra en la vista
                // MARK: WARNING lazy stacks tienen un ancho flexible con preferencia, por lo que van a ocupar espacio disponible en una manera que los stacks comunes no.
                // Por ejemplo, si se reemplaza LazyVStack con un VStack normal, para poder scrollear tenes que arrastrar sobre el texto, si no no funciona
                // SwiftUI va a crear las vistas la primera vez que se muestren. Despues de eso van a permanecer en memoria
                ScrollView {
                    LazyVStack {
                        ForEach(1...1000, id: \.self) { value in
                            SampleRow(id: value)
                        }
                    }
                }
                .frame(height: 100)
                
                // MARK: Grids
                // Permite crear grillas estaticas con control preciso sobre que va en cada fila y columna
                // Funciona igual que HStacks y VStacks, carga todo de una
                // Es ideal para layouts FIJOS
                Grid {
                    GridRow {
                        Text("Top Leading")
                            .background(.red)
                        Text("Top Trailing")
                            .background(.orange)
                    }
                    GridRow {
                        Text("Bottom Leading")
                            .background(.green)
                        Text("Bottom Trailing")
                            .background(.blue)
                    }
                }
                .font(.title)
                .padding()
                .border(.gray)
                
                // Si se ponen una cantidad de celdas desigules, por defecto SwiftUI va a rellenar la grilla con celdas vacias
                VStack {
                    Grid {
                        GridRow {
                            Text("Red")
                            ForEach(0..<redScore, id: \.self) { _ in
                                    Rectangle()
                                    .fill(.red)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        Divider() // Como no esta dentro de GridRow ocupa toda una fila
                        GridRow {
                            Text("Blue")
                            ForEach(0..<blueScore, id: \.self) { _ in
                            Rectangle()
                                    .fill(.blue)
                                    .frame(width: 20, height: 20)
                            }
                        }
                    }
                    
                    Button("Add to Red") { redScore += 1 }
                    Button("Add to Blue") { blueScore += 1 }
                }
                .padding()
                .border(.gray)
            
                
                // gridCellColumns() hace que una celda ocupe varias columnas
                Grid {
                    GridRow {
                        Text("Food")
                        Text("$200")
                    }
                    GridRow {
                        Text("Rent")
                        Text("$800")
                    }
                    GridRow {
                        Text("Candles")
                        Text("$3600")
                    }
                    Divider()
                    GridRow {
                        Text("$4600")
                            .gridCellColumns(2)
                    }
                }
                .padding()
                .border(.gray)
            }
            if lazyGrids {
                // MARK: LazyGrid -> 3 componentes -> la data cruda, un array de GridItem y describir si queres HGrid o VGrid
                // @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
                // usar .adaptive va a hacer que meta la mayor cantidad de columnas posibles, con minimo de 80
                ScrollView {
                    LazyVGrid (columns: [GridItem(.adaptive(minimum: 80))]) {
                        ForEach(data, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 100)
                
                // Para tener mas control sobre la cantidad de columnas se puede usar .flexible()
                ScrollView {
                    LazyVGrid (columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(data, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 100)
                
                // si no esta .fixed(), Se puede mezclar con .flexible y va a ocupar es espacio restante
                ScrollView {
                    LazyVGrid (columns: [GridItem(.fixed(60)), GridItem(.fixed(100)),  GridItem(.flexible())]) {
                        ForEach(data, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 100)
                
                // Grid Horizontal LazyHGrid
                // Acepta ROWS en vez de columnas
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(40)), GridItem(.fixed(40))], alignment: .center) {
                        ForEach(items, id: \.self) { item in
                            Image(systemName: "\(item).circle.fill")
                                .font(.title)
                        }
                    }
                }
                .frame(height: 100)
                
                // Alternativa para iOS 13 -> GridStack
            }
            if tableYScrollBehaviour {
                // MARK: Dismiss keyboard -> scrollDismissesKeyboard()
                // @available iOS 16
                ScrollView {
                    VStack {
                        TextField("Name", text: $username)
                            .textFieldStyle(.roundedBorder)
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .border(.quaternary, width: 1)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
                // 4 tipos de modificadores:
                // - .automatic -> se ocupa SwiftUI basado en el context del scroll
                // - .immediately -> se esconde el teclado apenas hay algun movimiento de scroll
                // - .interactively -> se tiene que scrollear mas para que se esconda el teclado
                // - .never -> para que no se esconda el teclado con el scrolling de ninguna manera
                .scrollDismissesKeyboard(.interactively)
                // Segun Apple: text editors -> interactive por default / el resto -> immediate
                
                // MARK: Hide scroll indicators
                // @available iOS 16
                List(1..<100) { i in
                    Text("Row \(i)")
                }
                .scrollIndicators(.hidden)
                .frame(height: 100)
                
                // MARK: Create multi-column lists using Table
                // @available iOS 16
                
                // SwiftUI tiene un tipo de vista dedicado para crear listas con multiples columnas -> TABLE
                // MARK: En iPhones las tablas colapsan para mostrar solo la primer columna, pero en iPad y Mac muestra todo
                // Usamos @State para poder hacer sorting
                // La segunda columna no usa un keyPath porque toma el valor del objeto y crea una vista custom
                // Solo se puede usar keyPath para el value si es un string simple, para todo lo demas se necesita algo custom
                Table(users) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Score") { user in
                        Text(String(user.score))
                    }
                }
                .frame(maxHeight: 200)
                
                // Cuando se selecciona un elemento de la tabla en vez de guardarlo se crea un identificador del objeto
                // Como usuario conforma a identifiable, el identificador puede ser User.ID
                // si se necesita seleccion multiple selection = Set<User.ID>
                // Para poder hacer sorting se necesita un array de KeyPathComparator
                // Se puede usar row para usar filas fijas o hacer una mezcla
                // como la primera y la ultima fila son fijas, no se van a alterar por el sorting
                Table(selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Score") { user in
                        Text(String(user.score))
                    }
                    .width(min:70, max:100)
                } rows: {
                    TableRow(User(id: 0, name: "First", score: 0))
                    ForEach(users, content: TableRow.init)
                    TableRow(User(id: 4, name: "Last", score: 100))
                }
                .onChange(of: sortOrder) {
                    users.sort(using: sortOrder)
                }
                
                
                
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
}

private struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat?
    let content: () -> Content
    
    init(horizontalAlignment: HorizontalAlignment = .center, verticalAlignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        Group {
            if sizeClass == .compact {
                VStack(alignment: horizontalAlignment, spacing: spacing, content: content)
            } else {
                HStack(alignment: verticalAlignment, spacing: spacing, content: content)
            }
        }
    }
}

private struct SampleRow: View {
    let id: Int
    
    var body: some View {
        Text("Row \(id)")
    }
    
    init(id: Int) {
        print("Loading row \(id)")
        self.id = id
    }
}

private struct User: Identifiable {
    let id: Int
    var name: String
    var score: Int
}

#Preview {
    StackGridsScrollviewView()
}
