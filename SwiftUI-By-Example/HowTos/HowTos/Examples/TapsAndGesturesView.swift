//
//  TapsAndGesturesView.swift
//  HowTos
//
//  Created by Santiago Cento on 27/04/2024.
//

import SwiftUI

struct TapsAndGesturesView: View {
    @State private var scale = 1.0
    @State private var dragOffset = CGSize.zero
    @State private var message = "Long press then drag"
    @State private var overText = false
    
    @State private var simple = true
    
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
                // Se puede agregar GestureRecognizer a cualquier view
                // y el GestureRecognizer puede tener un closure que se corra cuando se activa mediante el gesto
                // Se pueden poner varios gestos a una misma view
                Image("perrito")
                    .offset(dragOffset)
                    .scaleEffect(scale)
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                scale += 0.1
                            }
                    )
                    .gesture(
                        LongPressGesture(minimumDuration: 1)
                            .onEnded { _ in
                                scale = 1.0
                            }
                    )
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onChanged { gesture in
                                dragOffset = gesture.translation
                            }
                            .onEnded { _ in
                                dragOffset = .zero
                            }
                    )
                // Tambien las vistas tienen el modificador onTapGesture que hace mas comodo todo
                Text("Tap me!")
                    .padding()
                    .onTapGesture {
                        print("tapped!")
                    }
                // se le puede especificar la cantidad de toques
                Text("Tap me!")
                    .padding()
                    .onTapGesture(count: 3, perform: {
                        print("triple tapped!")
                    })
                
                // Si hay una vista dentra de otra y ambas tienen el mismo gesture recognizer
                // SwiftUI siempre va a disparar primero el del hijo
                // Para forzar un gesto por encima de otro se usa highPriorityGesture()
                VStack {
                    Circle()
                        .fill(.teal)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            print("Circle tapped!")
                        }
                }
                .highPriorityGesture(
                    TapGesture()
                        .onEnded { _ in
                            print("VStack tapped!")
                        }
                )
                
                // SwiftUI siempre va a ejecutar un solo gesureRecognizer por vez
                // para cambiar eso usar simultaneousGesture()
                // Usar simultaneousGesture con el gesture que no fuera a ejecutarse si no lo usaramos
                // (en este caso el del VStack)
                VStack {
                    Circle()
                        .fill(.teal)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            print("Circle tapped!")
                        }
                }
                .simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            print("VStack tapped!")
                        }
                )
                
                // Ejecutar cadena de Gestures usando sequenced(before:)
                // Permite triggerear una accion solo cuando 2 gestos ocurren uno despues del otro
                // No se pueden crear como propiedades de la view, se tienen que crear dentro del body
                let longPress = LongPressGesture()
                    .onEnded { _ in
                        message = "Now drag me"
                    }
                let drag = DragGesture()
                    .onEnded { _ in
                        message = "Success!"
                    }
                let combined = longPress.sequenced(before: drag)
                Text(message)
                    .gesture(combined)
                
                // Detectar hovering sobre una view en macOS y iPadOS
                // hoverEffect() permite elegir 3 maneras de highlight
                // .highlight transforma el pointer en la forma de la view
                // .lift hace lo mismo pero agranda la view y le agrega sombra
                // .automatic SwiftUI decide alguno de los 2 dependiendo lo que sea mas conveniente
                // .automatic es el default
                // ctrl + cmd + K para mandar el mouse al ipad en sim
                Text("Esto es para probar el hover")
                    .foregroundStyle(overText ? .green : .red)
                    .hoverEffect(.lift)
                    .onHover { over in
                            overText = over
                    }
                
                // Detectar shake del device
                // No hay manera nativa pero se puede hacer override de motionEnded() en UIWindow
                // Al momento de hacer esto no funciona el onReceive() si no se le pone antes un onAppear()
                Text("Shake me!")
                    .onShake {
                        print("Device shaken!")
                    }
                
                // Deshabilitar taps usando allowsHitTesting()
                // Si algo tiene esto en false va a hacer que el tap pase a la vista de abajo
                ZStack {
                    Button("Tap me") {
                        print("button was tapped!")
                    }
                    .frame(width: 100, height: 40)
                    .background(.gray)
                    Rectangle()
                        .fill(.red.opacity(0.4))
                        .frame(width: 200, height: 60)
                        .clipShape(Capsule())
                        .allowsHitTesting(false)
                }
                
                // Detectar la location de un tap dentro de una view
                
            }
        }
        .padding()
        .overlay() {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        }
        // Controlar el area tappeable de una view con contentShape()
        // Si se agrega un gesto a una vista primitiva como Text o Image, toda la vista detecta el gesto
        // si se agrega a un VStack o HStack solo se aplica al contenido que tenga adentro
        // Ejemplo: (comentar linea para ver la diferencia)
        .contentShape(Rectangle())
        .onTapGesture {
            print("VStack tapped!")
        }
        .padding()
        Spacer()
    }
}

// MARK: - Detectar shake
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
// MARK: -
#Preview {
    TapsAndGesturesView()
}
