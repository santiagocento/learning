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
    @State private var transforms = true
    
    @State private var phase = 0.0
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                Toggle("Simple", isOn: $simple)
                Toggle("Bordes", isOn: $borders)
                Toggle("Shadows", isOn: $shadows)
                Toggle("Transforms", isOn: $transforms)
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
