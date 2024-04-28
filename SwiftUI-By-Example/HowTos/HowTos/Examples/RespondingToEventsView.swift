//
//  RespondingToEventsView.swift
//  HowTos
//
//  Created by Santiago Cento on 24/04/2024.
//

import SwiftUI

struct RespondingToEventsView: View {
    let sports = ["figure.badminton", "figure.cricket", "figure.fencing"]
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var name = ""
    
    @FocusState var isInputActive: Bool
    
    @State private var messages = [Message]()
    
    @State private var isShowingFindNavigator: Bool = false
    
    @State private var message = ""
    
    @State private var image = Image(systemName: "photo")
    @State private var dropImage = Image(systemName: "photo")
    @State private var images = [Image]()
    
    @State private var simple = false
    @State private var dragAndDrop = true
    
    var body: some View {
        VStack {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                    Toggle(isOn: $dragAndDrop, label: { Text("Drag and Drop") })
                }
            }
            if simple {
                Text("Eventos")
                // Detecta si la app se va al background o entra en el foreground
                // a partir de iOS 17 se requiere que tenga el valor nuevo y el viejo en el closure
                    .onChange(of: scenePhase) { newPhase, oldPhase  in
                        handlePhases(phase: newPhase)
                    }
                // Lifecycle Events
                // onAppear() -> viewDidAppear() / onDisappear() -> viewDidDisappear()
                    .onAppear {
                        print("texto aparece")
                    }
                    .onDisappear {
                        print("texto desaparece")
                    }
                
                // En iPadOS y macOS se pueden agregar atajos de teclado
                Button("Log in") { print("logueando") }
                // Esto hara que usando Cmd+L se ejecute lo del boton
                // No se necesita especificar el Cmd porque SwiftUI lo asume a menos que digamos lo contario
                    .keyboardShortcut("l", modifiers: [.command, .option])
                
                // La otra es usar las built-in keys (Escape, arrows, semantic keys por ej cancelar o enter)
                // Esto va a hacer que al apretar el enter se realice la accion
                Button("Confirm") { print("confirmado") }
                    .keyboardShortcut(.defaultAction)
                
                // Para detectar la rotacion del dispositivo no hay manera nativa de hacerlo
                // la forma es respondiendo a la notificación UIDevice.orientationDidChangeNotification
                Group {
                    if orientation.isPortrait {
                        Text("Portrait")
                    } else if orientation.isLandscape {
                        Text("Landscape")
                    } else if orientation.isFlat {
                        Text("Flat")
                    }  else {
                        Text("Unkown")
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }
                
                // Agregar toolbar a keyboard
                // Esta bueno para usarlo con @FocusState
                TextField("Enter your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Listo!") {
                                isInputActive = false
                            }
                        }
                    }
                
                // Permitir pegar data en nuestra app con PasteButton
                // Se puede usar con cualquier tipo de data que conforme con Transferable, como String y Data
                // Dado que TextField tiene su propio cut, copy y paste menu options,
                // PasteButton va a hacer mejor utilizado en lugares donde no se este manejando text,
                // como cuando hay que pegar una imagen en la app
                PasteButton(payloadType: String.self) { strings in
                    guard let first = strings.first else { return }
                    name = first
                }
                .buttonBorderShape(.capsule)
                
                // Correr tasks asíncronas cuando se muestra una vista con task()
                // es como onAppear() pero mas potente
                // si no terminó cuando la vista es destruida, se cancela automaticamente
                // Es un buen lugar si se necesita hacer alguna data de internet
                // se puede attachear .task() a cualquier View, va a ejecutarse en cuanto la vista se muestre
                // Tareas creadas con task() van a tener la mayor prioridad posible, pero se puede modificar
                List(messages) { message in
                    VStack(alignment: .leading) {
                        Text(message.from)
                            .font(.headline)
                        Text(message.text)
                    }
                }
                .task {
                    do {
                        let url = URL(string: "https://www.hackingwithswift.com/samples/messages.json")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        messages = try JSONDecoder().decode([Message].self, from: data)
                    } catch {
                        messages = []
                    }
                }
                .frame(maxHeight: 200)
                
                // Permitir compartir contenido usando el sistema de share sheet con ShareLink
                // Por default se obtiene un boton simple de Share, obvio se puede modificar
                ShareLink(item: name)
                ShareLink("Compartir nombre", item: name)
                ShareLink(item: name, message: Text("compartir"), preview: SharePreview(
                    "Switzerland's flag: it's a big plus",
                    image: Image(systemName: "plus")
                ))  {
                    Label("Nombre", systemImage: "swift")
                }
                
                // Permitir al usuario buscar y reemplazar texto
                // TextEditor trae nativo el comportamiento cuando se tiene un teclado fisico (opt + cmd + F)
                // NO funciona con TextField
                // usar findNavigator() para mostrar la interfaz para usuarios sin teclado fisico
                TextEditor(text: $name)
                    .findNavigator(isPresented: $isShowingFindNavigator)
                // Por algun motivo esto funciona pero toma el keyboard toolbar del otro
                // TODO: Averiguar porque todo esto no funciona
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Find/Replace") {
                                isShowingFindNavigator.toggle()
                            }
                        }
                    }
                    .frame(maxHeight: 100)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray, lineWidth: 2)
                    }
            }
            if dragAndDrop {
                // Drag and drop
                // El protocolo Transferable tambien permite hacer drag and drop
                // se usa dropDestination() y draggable()
                // Esto va a aceptar arrastrar un texto a la app y mostrarlo en un Canvas
                
                ScrollView {
                    Canvas { context, size in
                        let formattedText = Text(message)
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        context.draw(formattedText, in: CGRect(origin: .zero, size: size))
                    }
                    .frame(height: 200)
                    .overlay() {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray, lineWidth: 2)
                    }
                    // Parte clave
                    .dropDestination(for: String.self) { items, location in
                        message = items.first ?? ""
                        return true
                    }
                    // Esto nos dice 4 cosas
                    // - solo acepta strings
                    // - espera recibir un array de items que fueran dropeados en la app. Automaticamente es un array de String
                    // - CGPoint nos va a indicar donde fue dropeado en las coordenadas del canvas
                    // - retorna true porque consideramos la operacion de drop exitosa
                    
                    // Con imagenes se complica un poco porque nos da Data representando la imagen
                    // hay que convertirlo a UIImage y poner el resultado en un Image para que lo renderice
                    // Si soportamos Data como destino por suerte todo funciona
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .dropDestination(for: Data.self) { items, location in
                            guard let item = items.first else { return false }
                            guard let uiImage = UIImage(data: item) else { return false }
                            image = Image(uiImage: uiImage)
                            return true
                        }
                    
                    // Se acepta un array, con lo que podemos hacer que directamente se muestren todas las imagenes que se dropeen en la app
                    ScrollView {
                        VStack {
                            ForEach(0..<images.count, id: \.self) { i in
                                images[i]
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 200)
                    .overlay() {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray, lineWidth: 2)
                    }
                    .dropDestination(for: Data.self) { items, location in
                        images = items.compactMap {
                            UIImage(data: $0).map(Image.init)
                        }
                        return true
                    }
                    
                    // Usar draggable() con cualquier Transferable
                    // Por default SwiftUI usa la misma vista para el preview
                    // Si ser esta haciendo dragging the una imagen dentro de la app se puede usar Image.self en vez de hacer todo el drama de Data
                    VStack {
                        HStack {
                            ForEach(sports, id: \.self) { sport in
                                Image(systemName: sport)
                                    .frame(minWidth: 50, minHeight: 50)
                                    .background(.red)
                                    .foregroundStyle(.white)
                                    .draggable(Image(systemName: sport))
                            }
                        }
                    }
                    
                    dropImage
                        .frame(width: 150, height:150)
                        .background(.green)
                        .dropDestination(for: Image.self) { items, location in
                            dropImage = items.first ?? Image(systemName: "photo")
                            return true
                        }
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

func handlePhases(phase: ScenePhase) {
    if phase == .inactive { // Visible pero el usuario no puede interactuar (ej multi-tasking mode)
        print("inactive")
    } else if phase == .active { // en el foreground y el usuario puede interactuar
        print("active")
    } else if phase == .background { // No Visible
        print("background")
    }
}

// MARK: - Pasos necesarios para detectar Device rotation
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

// MARK: -

private struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let text: String
}

#Preview {
    RespondingToEventsView()
}
