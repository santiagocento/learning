//
//  AnimationsView.swift
//  HowTos
//
//  Created by Santi on 24/03/2025.
//

import SwiftUI

struct AnimationsView: View {
    
    @State private var simple = false
    @State private var advanced = true
    
    @Namespace private var animationNamespace // nos permite unir views
    
    @State private var scale = 1.0
    @State private var opacity = 1.0
    @State private var angle = 0.0
    @State private var borderThickness = 1.0
    @State private var isEnabled = false
    @State private var isZoomed = false
    @State private var showDetails = false
    @State private var isShowingRed = false
    @State private var fontSize = 32.0
    
    @State private var triggerPhaseAnimation = false
    
    // Diferencia entre .animation() y withAnimation es que el primero aplica solo a la vista que esta modificando
    // withAnimation va a animar todas las vistas que usen el valor modificado
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                // Por default, SwiftUI usa fade in fade out animations para manejar aparicion de vistas
                // usar .transition(.slide) o similar para modificarlo
                Toggle("Simple", isOn: $simple.animation(.bouncy()))
                Toggle("Advanced", isOn: $advanced.animation(.bouncy()))
            }
            .gridCellColumns(2)
            
            if simple {
                Button("Cirujano, estírela") {
                    scale += 0.1
                    borderThickness += 1
                }
                .padding()
                .scaleEffect(scale, anchor: .center)
                .border(.red, width: borderThickness)
                .animation(.easeIn.delay(1), value: scale)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Button("A rotar y a rotar") {
                        angle += 45
                    }
                    .padding()
                    .rotationEffect(.degrees(angle))
                    // Interpolating significa que si se aplica mas de una vez, el efecto se vuelve mas y mas fuerte
                    .animation(.interpolatingSpring(mass: 1, stiffness: 1,
                                                    damping: 0.5, initialVelocity: 10), value: angle)
                    
                    Button("Oscurecer") {
                        withAnimation(.bouncy(duration: 0.5)) {
                            opacity -= 0.2
                        }
                    }
                    .opacity(opacity)
                }
                
                Circle()
                    .frame(width: 100, height: 50)
                    .scaleEffect(scale)
                    .animateForever(autoreverses: true) {
                        scale = 0.9
                    }
                
                Button("Press Me") {
                    isEnabled.toggle()
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(isEnabled ? .green : .red)
                .animation(nil, value: isEnabled) // Este animation nil hace que no se anime el cambio de background
                .clipShape(RoundedRectangle(cornerRadius: isEnabled ? 100 : 0))
                .animation(.easeIn(duration: 0.5), value: isEnabled)
                
                VStack {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.blue)
                            .frame(width: isZoomed ? 100 : 44, height: isZoomed ? 100 : 44)
                            .padding(.top, isZoomed ? 8 : 0)
                        
                        if isZoomed == false {
                            Text("Taylor Swift – 1989")
                                .matchedGeometryEffect(id: "AlbumTitle", in: animationNamespace)
                                .font(.headline)
                            Spacer()
                        }
                    }
                    
                    if isZoomed == true {
                        Text("Taylor Swift – 1989")
                            .matchedGeometryEffect(id: "AlbumTitle", in: animationNamespace)
                            .font(.headline)
                        Spacer()
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        isZoomed.toggle()
                    }
                }
                .padding()
                .frame(height: 150)
                .background(Color(white: 0.9))
                .foregroundColor(.black)
                
                VStack {
                    Button("Mostrar .transition()") {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                    if showDetails {
                        // Moves in from the bottom
                        Text(".move(edge: .bottom)")
                            .transition(.move(edge: .bottom))
                        
                        // Moves in from leading out, out to trailing edge.
                        Text(".slide")
                            .transition(.slide)
                        
                        // Starts small and grows to full size.
                        Text(".scale")
                            .transition(.scale)
                        
                        Text(".slide combinado con opacity")
                            .transition(AnyTransition.opacity.combined(with: .slide))
                        
                        Text("custom transition")
                            .transition(.moveAndScale)
                        
                        Text("Asymetric transition")
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .bottom)))
                    }
                }
                
                // Custom Transition
                ZStack {
                    Color.blue
                        .frame(width: 100, height: 100)
                    
                    if isShowingRed {
                        Color.red
                            .frame(width: 100, height: 100)
                            .transition(.iris)
                            .zIndex(1)
                    }
                }
                .padding(10)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isShowingRed.toggle()
                    }
                }
                
                Text("Animatable text")
                    .animatableFont(name: "Georgia", size: fontSize)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1).repeatForever()) {
                            fontSize = 44
                        }
                    }
            }
            
            if advanced {
                HStack(spacing: 20) {
                    Button("Notificar") {
                        print("tuvieja")
                        triggerPhaseAnimation.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .fontWeight(.semibold)
                    .tint(.red.mix(with: .orange, by: 0.1))
                    .controlSize(.large)
                    
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.red.mix(with: .orange, by: 0.2))
                        .phaseAnimator([
                            NotifyAnimationPhase.initial,
                            NotifyAnimationPhase.lift,
                            NotifyAnimationPhase.shakeLeft,
                            NotifyAnimationPhase.shakeRight,
                            NotifyAnimationPhase.shakeLeft,
                            NotifyAnimationPhase.shakeRight,
                            NotifyAnimationPhase.final
                        ], trigger: triggerPhaseAnimation) { content, phase in
                            content
                                .scaleEffect(phase.scale)
                                .rotationEffect(.degrees(phase.rotationDegrees), anchor: .top)
                                .offset(y: phase.yOffset)
                        } animation: { phase in
                            switch phase {
                            case .initial, .lift: .spring(bounce: 0.5)
                            case .shakeLeft, .shakeRight, .final: .easeInOut(duration: 0.15)
                            }
                        }
                }
                .padding(20)
                
                // Deshabilitar y/o reemplazar animaciones usando transaction o .transaction() para aplicar a una sola vista
                Button("Toggle Zoom") {
                    var transaction = Transaction(animation: .linear)
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isZoomed.toggle()
                    }
                }
                
                Spacer()
                    .frame(height: 100)
                
                Text("Zoom Text")
                    .font(.title)
                    .scaleEffect(isZoomed ? 3 : 1)
                    .animation(.easeInOut(duration: 2), value: isZoomed)
                
                Text("Otro Zoom Text")
                    .font(.title)
                    .scaleEffect(isZoomed ? 3 : 1)
                    .transaction { t in
                        t.animation = .none
                    }
            }
            Spacer()
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
    AnimationsView()
}

// Necesitamos 3 cosas para una custom transition
// Un ViewModifier
// Una extension de AnyTransition
// usarolos en un .transition()

struct ScaledCircle: Shape {
    // This controls the size of the circle inside the
    // drawing rectangle. When it's 0 the circle is
    // invisible, and when it’s 1 the circle fills
    // the rectangle.
    var animatableData: Double
    
    func path(in rect: CGRect) -> Path {
        let maximumCircleRadius = sqrt(rect.width * rect.width + rect.height * rect.height)
        let circleRadius = maximumCircleRadius * animatableData
        
        let x = rect.midX - circleRadius / 2
        let y = rect.midY - circleRadius / 2
        
        let circleRect = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)
        
        return Circle().path(in: circleRect)
    }
}

// A general modifier that can clip any view using a any shape.
struct ClipShapeModifier<T: Shape>: ViewModifier {
    let shape: T
    
    func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}

// A modifier that animates a font through various sizes.
struct AnimatableCustomFontModifier: ViewModifier, Animatable {
    var name: String
    var size: Double
    
    var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
    }
}

// To make that easier to use, I recommend wrapping
// it in a `View` extension, like this:
extension View {
    func animatableFont(name: String, size: Double) -> some View {
        self.modifier(AnimatableCustomFontModifier(name: name, size: size))
    }
}

// A custom transition combining ScaledCircle and ClipShapeModifier.
extension AnyTransition {
    static var iris: AnyTransition {
        .modifier(
            active: ClipShapeModifier(shape: ScaledCircle(animatableData: 0)),
            identity: ClipShapeModifier(shape: ScaledCircle(animatableData: 1))
        )
    }
}

// Create an immediate animation.
extension View {
    func animate(using animation: Animation = .easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}

// Create an immediate, looping animation
extension View {
    func animateForever(using animation: Animation = .easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)
        
        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}

extension AnyTransition {
    static var moveAndScale: AnyTransition {
        AnyTransition.move(edge: .bottom).combined(with: .scale).animation(.linear(duration: 0.01))
    }
}

enum NotifyAnimationPhase {
    case initial, lift, shakeLeft, shakeRight, final
    
    var yOffset: CGFloat {
        switch self {
        case .initial: 0
        case .lift, .shakeLeft, .shakeRight, .final: -30
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .initial: 1
        case .lift, .final: 1.2
        case .shakeLeft, .shakeRight: 1.2
        }
    }
    
    var rotationDegrees: Double {
        switch self {
        case .initial, .lift, .final: 0
        case .shakeLeft: -30
        case .shakeRight: 30
        }
    }
}
