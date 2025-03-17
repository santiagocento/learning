//
//  LayoutViews.swift
//  HowTos
//
//  Created by Santiago Cento on 30/03/2024.
//

import SwiftUI

struct LayoutViews: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State private var simple = false
    @State private var differentViewsAndLoops = false
    @State private var layoutYFrames = false
    @State private var safeAreaInsets = false
    @State private var dynamicYCustom = false
    @State private var viewThatFits = true
    
    var body: some View {
        List {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                    Toggle(isOn: $differentViewsAndLoops, label: { Text("Loops") })
                    Toggle(isOn: $layoutYFrames, label: { Text("Layouts") })
                    Toggle(isOn: $safeAreaInsets, label: { Text("Safe Area Insets") })
                    Toggle(isOn: $dynamicYCustom, label: { Text("Dynamic & Custom") })
                    Toggle(isOn: $viewThatFits, label: { Text("ViewThatFits") })
                }
            }
            if simple {
                // MARK: - Simple
                // Por default, las vistas en SwiftUI ocupan solo el espacio que necesitan, con .frame() se puede manipular eso
                CenteredContainerView {
                    Text("Welcome")
                        .frame(minWidth: 0, maxWidth: 160, minHeight: 0, maxHeight: 80)
                        .font(.largeTitle)
                        .background(.red)
                    
                    Text("Please log in")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .background(.red)
                    // .ignoresSafeArea() para ir mas alla
                    
                    VStack {
                        Text("Using")
                        Text("SwiftUI")
                            .padding(.bottom, 40)
                        Text("rocks")
                    }
                    
                    // Siempre es mejor dejar que SwiftUI maneje los layouts automaticamente con stacks,
                    // pero se puede dar tamaños relativos a las vistas usando GeometryReader
                    // GeometryReader no tiene en cuenta offsets o spacing por eso se pone en 0, si no se pasa
                    // tambien esta .safeAreaInset() que permite lo mismo pero tambien ajustar los elementos restantes y mantener la safe area
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Text("Left")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                                .frame(width: geometry.size.width * 0.33)
                                .background(.yellow)
                            Text("Right")
                                .font(.largeTitle)
                                .foregroundStyle(.black)
                                .frame(width: geometry.size.width * 0.67)
                                .background(.orange)
                        }
                    }.frame(height: 50)
                    
                    
                }.padding(.vertical)
                
                // Foreground Styles
                CenteredContainerView {
                    // Aparte de foregroundColor (agregando .tertiary y .quaternary), podes meter cualquier cosa que conforme con ShapeStyle
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Set time")
                    }
                    .font(.title.bold())
                    .foregroundStyle(.quaternary)
                    
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("Set time")
                    }
                    .font(.title.bold())
                    .foregroundStyle(
                        .linearGradient(colors: [.red, .gray], startPoint: .top, endPoint: .bottom)
                    )
                }
            }
            if differentViewsAndLoops {
                // DIFFERENT VIEWS
                CenteredContainerView {
                    //      La propiedad body automaticamente gana la habilidad de retornar diferentes vistas
                    // gracias a el atributo especia @ViewBuilder -> Implementado usando el result builder system
                    // y entiende como mostrar la vista dependiendo del estado de la app.
                    //      Esta misma funcionalidad no esta presente en todos lados por lo que cualquier propiedad
                    // custom tiene que retornar el mismo view type.
                    
                    //      Hay 4 maneras de resolver esto:
                    
                    // 1: Envolver todo en un Group, cosa de que siempre va a retornar la misma vista pero con diferente contenido adentro.
                    Variables.tossResultGroup
                    
                    // 2: La otra es usar el type-erased wrapper AnyView, tiene un costo de performance
                    // Preferir Group antes que AnyView, es mas eficiente
                    Variables.tossResultTypeErased
                    
                    // 3: Usar @ViewBuilder en el atributo que lo requiera
                    // Funciona, pero si hay que usar @ViewBuilder, capaz se esta poniendo mucho en una vista
                    Variables.tossResultViewBuilder
                    
                    // 4: La que funciona mejor la mayoria de las veces, es separar las vistas en vistas mas chicas y combinarlas despues
                    // Se aprovecha a separar la logica y layout, ademas de que hace las vistas mas reutilizables
                    //SwiftUI va a colapsar la gerarquia de vistas asique no hay practicamente diferencia de performance
                    TossResult()
                }
                // LOOPS
                CenteredContainerView {
                    // ForEach es una vista - no es un metodo forEach()
                    // Cada elemento tiene que poder ser identificado
                    // \.self identifica cada elemento usando su propio valor como referencia
                    ForEach(Variables.colors, id: \.self) { color in
                        Text(color.description.capitalized)
                            .background(color)
                    }
                    
                    // Usando una propiedad id
                    ForEach(Variables.results, id: \.id) { result in
                        Text("Result: \(result.score)")
                    }
                    
                    // Con protocolo Identifiable
                    ForEach(Variables.identifiableResults) { result in
                        Text("Result: \(result.score)")
                    }
                }
            }
            if layoutYFrames {
                // Layout Priority
                CenteredContainerView {
                    HStack {
                        Text("The rain Spain falls mainly on the Spaniards.")
                            .border(.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        Text("Knowledge first, France second.")
                            .border(.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    }
                    Divider()
                    HStack {
                        Text("The rain Spain falls mainly on the Spaniards.")
                            .border(.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        Text("Knowl first, France second.")
                            .border(.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .layoutPriority(1)
                    }
                }
                
                // Hacer vistas del mismo tamaño con frame y fixedSize
                CenteredContainerView {
                    HStack {
                        Text("This is a short string.")
                            .padding()
                            .frame(maxHeight: .infinity) // se necesita setear el maxHeight para que ocupe todo el espacio disponible
                            .background(.green)
                        Text("This is a very long string with lots of text that will run across multiple lines.")
                            .padding()
                            .frame(maxHeight: .infinity)
                            .background(.red)
                    }
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    VStack {
                        Button("Log In") { }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .clipShape(Capsule())
                        Button("Reset Password") { }
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.red)
                            .clipShape(Capsule())
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            }
            if dynamicYCustom {
                // Cambiar dinamicamente entre HStack y VStack basado en el contexto
                // MARK: - AnyLayout
                CenteredContainerView {
                    let layout = dynamicTypeSize <= .xLarge ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
                    layout {
                        Image(systemName: "1.circle")
                        Image(systemName: "2.circle")
                        Image(systemName: "3.circle")
                    }
                    .font(.largeTitle)
                }
                
                // MARK: deferSystemGestures()
                CenteredContainerView {
                    // prioriza nuestros gestos por sobre los del sistema
                    // cambia el comportamiento de control center por ejemplo, requiriendo 2 swipes para bajarlo
                    Text("Arrastrá")
                        .contentShape(Rectangle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .gesture(DragGesture())
                        .defersSystemGestures(on: .all)
                }
                
                // MARK: Layout Protocol
                CenteredContainerView {
                    // DOS REQUERIMIENTOS:
                    // - Un metodo que retorne cuanto espacio necesita para sus subvistas.
                    // (puede ser llamado multiples veces para ver que tan flexible es el container)
                    // - Un metodo que ponga las subvistas efectivamente en su lugar.
                    // Se puede cachear estos calculos si son muy complejos pero seria raro tener que hacerlo
                    
                    // MARK: Importante
                    // puede que los calculos para width y height den nil
                    // por eso es comun llamar replacingUnspecifiedDimensions() para que llene esos datos
                    
                    RadialLayout {
                        ForEach(0..<16, id: \.self) { _ in
                            Circle()
                                .frame(width: 12, height: 12)
                        }
                    }
                    .frame(height: 100)
                }
            }
            if viewThatFits {
                // MARK: Adaptive Layout (ViewThatFits)
                CenteredContainerView {
                    // Permite seleccionar entre multiples posibles vistas la que mejor basado en lo que entra en el espacio disponible
                    // Van desde la mas preferible hasta la menos preferible
                    ViewThatFits {
                        Label("Welcome to Awesome App", systemImage: "bolt.shield").font(.largeTitle)
                        Label("Welcome", systemImage: "bolt.shield").font(.largeTitle)
                        Label("Welcome", systemImage: "bolt.shield")
                    }
                    // Otro ejemplo pero con stacks
                    ViewThatFits {
                        HStack(content: OptionsView.init)
                        VStack(content: OptionsView.init)
                    }
                    // Text Layouts
                    // El texto en SwiftUI siempre prefiere quedar en 1 sola linea
                    // En este caso, ViewThatFits esta midiendo el texto HORIZONTAL Y VERTICALMENTE
                    ViewThatFits {
                        HStack {
                            Text("The rain in Spain")
                            Text("falls mainly on the Spaniards")
                        }
                        VStack {
                            Text("The rain in Spain")
                            Text("falls mainlyon the Spaniards")
                        }
                    }
                    // PERO podemos decirle que tome una sola dimension en consideracion
                    ViewThatFits(in: .vertical) {
                        Text(Variables.terms)
                        
                        ScrollView {
                            Text(Variables.terms)
                        }
                    }
                }
                .padding()
            }
        }
        if safeAreaInsets {
            // safeAreaInset() permite poner elementos fuera de la safe area del dispositivo,
            // mientras que tambien ajusta su layout para que se mantengan visibles.
            // Achica el safe area para asegurarse que todo el contenido se vea.
            // Es diferente de ignoresSafeArea() que solo extiende la vista para que vaya hasta los bordes de la pantalla
            // Antes de 15.2 solo funcionaba en ScrollView, ahora tambien funciona con List y Form
            CenteredContainerView {
                List(1..<100) { i in
                    Text("Row \(i)")
                }
            }
            .safeAreaInset(edge: .bottom) {
                Text("Por fuera de la safe area")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.indigo)
            }
        }
    }
}

private struct Variables {
    static var tossResultGroup: some View {
        Group {
            if Bool.random() {
                Image("perrito")
            } else {
                Text("Sorry")
            }
        }
    }
    
    static var tossResultTypeErased: some View {
        if Bool.random() {
            AnyView(Image("perrito"))
        } else {
            AnyView(Text("Sorry"))
        }
    }
    
    @ViewBuilder static var tossResultViewBuilder: some View {
        if Bool.random() {
            Image("perrito")
        } else {
            Text("Sorry")
        }
    }
    
    static let colors: [Color] = [.red, .green, .blue]
    static let results = [
        SimpleGameResult(score: 7),
        SimpleGameResult(score: 10),
        SimpleGameResult(score: 8)
    ]
    static let identifiableResults = [
        IdentifiableGameResult(score: 7),
        IdentifiableGameResult(score: 10),
        IdentifiableGameResult(score: 8)
    ]
    
    static let terms = String(repeating: "abcde", count: 100)
}

private struct TossResult: View {
    var body: some View {
        if Bool.random() {
            Image("perrito")
        } else {
            Text("Sorry")
        }
    }
}

private struct SimpleGameResult {
    let id = UUID()
    let score: Int
}

private struct IdentifiableGameResult: Identifiable {
    let id = UUID()
    let score: Int
}

private struct RadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let radius = min(bounds.size.width, bounds.size.height) / 2
        let angle = Angle.degrees(360 / Double(subviews.count)).radians
        
        for (index, subview) in subviews.enumerated() {
            let viewSize = subview.sizeThatFits(.unspecified)
            let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
            let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
        
    }
}

private struct OptionsView: View {
    var body: some View {
        Button("Log in") { }
            .buttonStyle(.borderedProminent)
        Button("Create Account") { }
            .buttonStyle(.bordered)
        Spacer().frame(width: 50, height: 20)
        Button("Need Help?") { }
    }
}

#Preview {
    LayoutViews()
}
