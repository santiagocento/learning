//
//  UserInterfaceControls.swift
//  HowTos
//
//  Created by Santiago Cento on 16/04/2024.
//

import SwiftUI
import MapKit

struct UserInterfaceControlsView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.calendar) var calendar
    private var colors = ["Red", "Green", "Blue", "Tartan"]
    private let obeliscoCoordenates = CLLocationCoordinate2D(latitude: -34.60376, longitude: -58.38162)
    @State private var name = "Taylor"
    @State private var password = ""
    // Usar @FocusState para hacer aparecer o desaparecer el teclado
    @FocusState private var nameIsFocused: Bool
    // se puede usar un enum para usar el focus state en un form
    @FocusState private var focusedField: Field?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var emailAddress = ""
    
    @State private var bio = ""
    
    @State private var score = 0
    @State private var celsius: Double = 0
    
    @State private var selectedColor = "Red"
    
    @State private var birthday = Date.now
    
    @State private var downloadAmount = 10.0
    
    @State private var color: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
    
    @State private var position: MapCameraPosition = .automatic
    
    @State private var dates: Set<DateComponents> = []
    
    @State private var simple = false
    @State private var textFieldsSlidersPickers = false
    @State private var otherControls = false
    @State private var maps = false
    @State private var multiDatePicker = true
    @State private var others = false
    
    var body: some View {
        VStack {
            VStack {
                // Toda esta parte sirve de ejemplo
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    // Toggle Switch
                    // si se quisiera se puede usar un array de booleans
                    Toggle("Simple", isOn: $simple)
                    // .toggleStyle(.button)
                        .tint(.mint)
                    Toggle(isOn: $textFieldsSlidersPickers, label: { Text("TextF, Sliders & Pickers") })
                        .tint(.blue)
                    Toggle(isOn: $otherControls, label: { Text("Otros Controles") })
                    Toggle(isOn: $maps, label: { Text("Mapas") })
                    Toggle(isOn: $multiDatePicker, label: { Text("MultiDate Picker") })
                    Toggle(isOn: $others, label: { Text("Otros") })
                }
            }
            .padding(.bottom, 8)
            Divider()
            
            if simple {
                // En su naturaleza de framework declarativo, en SwiftUI si declaramos una variable es inerte,
                // si la cambiamos no va a modificar nada
                // pero si el indicamos @State vamos a poder decirle a SwiftUI que observe los cambios y podamos reaccionar frente a ellos
                // si llamamos a la variable sola, va a leer el valor nomas
                // con el $ le indicamos a SwiftUI que queremos actualizar ese valor en ese lugar cuando cambie
                
                // Button se puede usar con cualquier vista como label
                // sirve para por ejemplo poder darle mas padding y hacer que sea mas facil tocar el boton
                Button {
                    print("sarasa")
                } label: {
                    Image("perrito")
                        .padding(20)
                }
                //.contentShape(Rectangle())
                
                // ButtonRoles
                Button("Cualquier cosa", role: .destructive) { }
                    .buttonStyle(.borderedProminent)
                
                // Bordered buttons
                Button("Buy: $0.99") { }
                    .buttonStyle(.bordered)
                Button("Buy: $0.99") { }
                    .tint(.indigo)
                    .buttonStyle(.borderedProminent)
                
                // ControlGroup para agrupar vistas que esten relacionadas
                ControlGroup {
                    Button("First") { }
                    Button("Second") { }
                    Button("Third") { }
                }
                
                // Leer texto de un TextField
                // por default no tiene bordes
                // Entre comillas el placeholder
                TextField("Enter your name", text: $name)
                    .focused($nameIsFocused)
                    .onSubmit {
                        nameIsFocused = false
                    }
                // se puede deshabilitar la auto correccion con:
                    .disableAutocorrection(true)
                Text("Hello \(name)!")
                
                // Ejecutar algo cuando se hace submit del TextField
                SecureField("Password", text: $password)
                // Se puede modifical el estilo para que no sea el default
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        print("sarasa")
                    }
                
                // onCommit puede ser para cosas simples pero siempre conviene mas onSubmit porque captura TODO el texto que se submitea en ese contexto, por ejemplo un form
                Form {
                    TextField("Enter your name", text: $name)
                    
                    SecureField("Password", text: $password)
                }
                .onSubmit {
                    nameIsFocused = false
                    guard name.isEmpty == false && password.isEmpty == false else {
                        print("la cagaste")
                        return
                    }
                    print("ok!")
                }
                // se puede cambiar el boton azul del teclado con submitLabel()
                // funciona para aplicarlo al form o a un textfiel
                .submitLabel(.join)
                
                // Un ejemplo mas complejo
                // IMPORTANTE no usar un focus binding para 2 form fields diferentes
                // usar onAppear para focusear automaticamente el textfield cuando aparece la pantalla
                VStack {
                    TextField("Enter your first name", text: $firstName)
                        .focused($focusedField, equals: .firstName)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                    TextField("Enter your last name", text: $lastName)
                        .focused($focusedField, equals: .lastName)
                        .textContentType(.familyName)
                        .submitLabel(.next)
                    TextField("Enter your email address", text: $emailAddress)
                        .focused($focusedField, equals: .emailAddress)
                        .textContentType(.emailAddress)
                        .submitLabel(.join)
                }
                .onSubmit {
                    switch focusedField {
                        case .firstName:
                            focusedField = .lastName
                        case .lastName:
                            focusedField = .emailAddress
                        default:
                            print("Creando cuenta!")
                    }
                }
                .onAppear {
                    focusedField = .firstName
                }
            }
            if textFieldsSlidersPickers {
                // Expand TextFields al escribir el usuario
                TextField("Describe Yourself", text: $bio, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                // controlar el limite de alto, no de caracteres, con linelimit
                // reservesSpace hace que tome el tamaño del limite de lineas
                    .lineLimit(4, reservesSpace: true)
                
                // Formatear TextFields para números
                TextField("Enter Your Score", value: $score, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                Text("Tu puntaje es \(score)")
                
                // Slider
                // Parametros importantes: value, In (el range del slider), Step (cuanto cambia el value por paso del slider, opcional)
                Slider(value: $celsius, in: -100...100, step: 2)
                Text("Celcius: \(celsius, specifier: "%.2f")")
                
                // Picker
                // Combina UIPickerView, UISegmentedControl y UITableView
                // El label sirve para el voiceOver por mas de que no se vea
                Picker("Choose a color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                // Segmented Control
                Picker("Color favorito", selection: $selectedColor) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                Text("Seleccionado \(selectedColor)")
                
                // DatePicker
                // tambien se puede usar displayedComponents: .hourAndMinute
                // in: ...Date.now es el rango de fechas seleccionable
                DatePicker(selection: $birthday, in: ...Date.now, displayedComponents: .date) {
                    Text("Fecha de cumple:")
                }
                //  .datePickerStyle(GraphicalDatePickerStyle()) -> Para ver un picker completo
                Text("Tu cumple es: \(birthday.formatted(date: .long, time: .omitted))")
                
                // SwiftUI Requiere que le pongamos un label a los controles
                // Manera correcta de esconder los labels: labelsHidden()
            }
            if otherControls {
                // Stepper
                // tambien se puede poner un rango con in:
                // Se puede usar onIncrement o onDecrement para poder reaccionar a los eventos en vez de proveer un value
                Stepper("Pone tu edad", value: $score, in: 0...130)
                Stepper("Pone tu edad", onIncrement: {
                    score += 1
                }, onDecrement: {
                    score -= 1
                })
                Text("Edad: \(score)")
                
                // Multi-line TextEditor
                // Para single-line conviene usar TextField
                NavigationStack {
                    TextEditor(text: $bio)
                        .foregroundStyle(.secondary)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .padding(.horizontal)
                        .navigationTitle("Sobre vos")
                    
                }
                .frame(maxHeight: 150)
                
                // ColorPicker
                ColorPicker("Seleccione un color", selection: $color,
                            // se puede sacar el alpha
                            supportsOpacity: false)
                
                // ProgressView con porcentaje
                ProgressView("Descargando...", value: downloadAmount, total: 100)
                
                // ProgressView generico
                ProgressView("Sigue Descargando...")
            }
            if maps {
                // Maps
                // https://blorenzop.medium.com/mapkit-swiftui-009a0eb1695c
                Map(position: $position, interactionModes: [.pan, .zoom]) {
                    // Simple
                    // Marker("Obelisco", coordinate: obeliscoCoordenates)
                    Annotation("Obelisco", coordinate: obeliscoCoordenates) {
                        Circle()
                            .fill(.teal)
                            .frame(width: 130, height: 130)
                            .overlay {
                                Image(systemName: "mappin.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                    }
                }
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .including([.museum])))
            }
            if others {
                Link("Aprende SwiftUI", destination: URL(string: "https://developer.apple.com/tutorials/swiftui")!)
                    .font(.title)
                    .foregroundStyle(.teal)
                
                Link(destination: URL(string: "https://www.apple.com")!) {
                    Image(systemName: "link.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.orange)
                }
                
                Button("Navegar a link desde código") {
                    openURL(URL(string: "https://www.apple.com")!)
                }
            }
            if multiDatePicker {
                // MultiDatePicker
                MultiDatePicker("Elegi tus fechas", selection: $dates, in: Date.now...)
                Text(dates.compactMap { components in
                    calendar.date(from: components)?.formatted(date: .long, time: .omitted)
                }.formatted())
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

private enum Field {
    case firstName
    case lastName
    case emailAddress
}

#Preview {
    UserInterfaceControlsView()
}
