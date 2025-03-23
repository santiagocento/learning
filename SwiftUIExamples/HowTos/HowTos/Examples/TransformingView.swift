//
//  TransformingView.swift
//  HowTos
//
//  Created by Santi on 20/03/2025.
//

import SwiftUI

struct TransformingView: View {
    
    @State private var simple = false
    @State private var borders = false
    @State private var shadows = false
    @State private var transforms = false
    @State private var otherTransforms = true
    
    @State private var progress = 0.2
    @State private var text = ""
    @State private var phase = 0.0
    @State private var isOn: Bool = false
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                Toggle("Simple", isOn: $simple)
                Toggle("Bordes", isOn: $borders)
                Toggle("Shadows", isOn: $shadows)
                Toggle("Transforms", isOn: $transforms)
                Toggle("Other Transforms", isOn: $otherTransforms)
            }
            .gridCellColumns(2)
            
            ScrollView(showsIndicators: false) {
                if simple {
                    Text("Texto")
                    Text("Este tiene offset")
                    // importante: el offset solo cambia la posicion en relacion a su propio posicionamiento
                    // no afecta a las vistas que la rodean
                        .offset(y: 15)
                    //.padding(.bottom, 15)
                    Text("Texto")
                        .padding()
                    
                    // Tampoco va a afectar modificadores que vengan despues
                    HStack {
                        Text("Antes")
                            .background(.teal)
                            .offset(y: 15)
                        Text("Despues")
                            .offset(y: 15)
                            .background(.teal)
                    }
                    
                    // puede servir para poner un pie de foto por ejemplo
                    ZStack(alignment: .bottomTrailing) {
                        Image(.perrito)
                            .resizable()
                            .frame(width: 200, height: 50)
                        Text("Photo: Santi.")
                            .font(.caption2)
                            .padding(4)
                            .background(.black)
                            .foregroundColor(.white)
                            .offset(x: -5, y: -5)
                    }
                    
                    // Stack modifiers, el orden obvio importa
                    Text("Forecast: Sun")
                        .foregroundColor(.white)
                        .padding()
                        .background(.red)
                        .padding()
                        .background(.orange)
                        .padding()
                        .background(.yellow)
                }
                if borders {
                    // Border para views, stroke o strokeBorder para shapes
                    Text("Borde simple")
                        .padding()
                        .border(.green, width: 4)
                    
                    Text("Borde mas complejo")
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.green, lineWidth: 4)
                        }
                        .padding(.horizontal)
                    
                    HStack {
                        // .strokeBorder() va a meter todo el ancho del lineWidth dentro de la vista
                        Circle()
                            .strokeBorder(.blue, lineWidth: 30)
                            .frame(width: 70, height: 70)
                            .border(.red, width: 1)
                            .padding()
                        // .stroke() va a dejar la mitad del lineWidth por fuera y la otra mitad por dentro
                        // del borde de la Shape
                        Circle()
                            .stroke(.blue, lineWidth: 30)
                            .frame(width: 70, height: 70)
                            .border(.red, width: 1)
                            .padding()
                    }
                    
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .bevel, miterLimit: 10, dash: [10], dashPhase: phase))
                        .frame(width: 200, height: 50)
                        .padding()
                        .onAppear {
                            withAnimation(.linear.repeatForever(autoreverses: false)) {
                                phase -= 20
                            }
                        }
                }
                if shadows {
                    HStack {
                        Circle()
                        // esto sirve para shapes nomas, usar .shadow() para otras cosas
                            .fill(.red.shadow(.drop(color: .black, radius: 7)))
                            .padding()
                            .frame(width: 100, height: 100)
                        Circle()
                        // esto sirve para shapes nomas, usar .shadow() para otras cosas
                            .fill(.red.shadow(.inner(color: .black, radius: 7)))
                            .padding()
                            .frame(width: 100, height: 100)
                    }
                    Text("Santi")
                        .padding()
                        .shadow(color: .red, radius: 4, x: 4, y: 6)
                        .border(.red, width: 4)
                    // si se aplica este shadow tambien se le aplica la sombra al borde
                    // .shadow(color: .red, radius: 4, x: 4, y: 6)
                    
                    Button {
                        print("Button was pressed!")
                    } label: {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 8)
                            .background(.green)
                            .clipShape(Capsule())
                    }
                }
                if transforms {
                    
                    Text("Doblado como el Pity")
                        .padding()
                        .rotationEffect(.degrees(-15))
                    
                    Text("Doblado como el Pi")
                    // anchor por defecto es center
                        .rotationEffect(.radians(-.pi / 8), anchor: .topLeading)
                    
                    Text("EPISODE LLVM")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                        .rotation3DEffect(.degrees(45), axis: (x: 1, y: 0, z: 0))
                    
                    Text("Escalado de texto")
                        .scaleEffect(x: 2, y: 1)
                        .frame(maxWidth: .infinity)
                    // El scaleEffect no redibuja la vista, la estira, asi que guarda que puede quedar pixelao
                    Text("Escalado de texto")
                        .scaleEffect(x: 2, y: 1, anchor: .bottomTrailing)
                    
                    Text(".cornerRadius asi solo")
                        .padding()
                        .background(.red)
                        .cornerRadius(12)
                    
                    Image(.perrito)
                        .resizable()
                        .frame(width: 200, height: 100)
                    // la diferencia con clipshape es que aplica tambien la transparencia que tenga, tipo png
                        .mask(Text("Mascara").font(.largeTitle))
                    
                    HStack {
                        Image(.perrito)
                        Image(.perrito)
                            .blur(radius: 2)
                        Text("Texto blureado")
                            .blur(radius: 2)
                    }
                    // Blend modes, .normal para que se vean los dos, el resto hace desaparecer partes o todo
                    ZStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 80, height: 80)
                            .offset(x: -10)
                            .blendMode(.normal)
                        Circle()
                            .fill(.blue)
                            .frame(width: 80, height: 80)
                            .offset(x: 10)
                            .blendMode(.colorBurn)
                    }
                    .frame(width: 100)
                }
                
                if otherTransforms {
                    HStack {
                        Image(.perrito)
                        
                        Image(.perrito)
                            .colorInvert()
                        
                        Image(.perrito)
                            .colorMultiply(.red)
                        
                        Image(.perrito)
                            .saturation(0.1)
                        
                        Image(.perrito)
                            .contrast(0.5)
                    }
                    
                    Button("Sarasa") {
                        print("eh sarasa")
                    }
                    .buttonStyle(SaltarinButton())
                    .padding()
                    
                    ProgressView(value: progress, total: 1.0)
                        .progressViewStyle(RelojitoProgressStyle())
                        .frame(width: 50, height: 50)
                        .contentShape(.rect)
                        .onTapGesture {
                            if progress < 1.0 {
                                withAnimation {
                                    progress += 0.2
                                }
                            } else {
                                progress = 0
                            }
                        }
                    Toggle("Check check", isOn: $isOn)
                        .toggleStyle(TildeToggleStyle())
                    
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .background(.linearGradient(colors: [.white, .gray], startPoint: .leading, endPoint: .trailing))
                        .frame(height: 50)
                    
                    // esconder el background usando .scrollContentBackground(.hidden)
                    // si no lo ponemos, no se aplica el background despues
                    List(0..<5) { i in
                        Text("Ejemplo \(i)")
                    }
                    .scrollContentBackground(.hidden)
                    .background(.indigo)
                    .frame(height: 200)
                }
            }
            .frame(maxWidth: .infinity)
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
    TransformingView()
}


struct SaltarinButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.teal)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct RelojitoProgressStyle: ProgressViewStyle {
    var strokeColor = Color.teal
    var strokeWidth = 12.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct TildeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(configuration.isOn ? .teal : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
