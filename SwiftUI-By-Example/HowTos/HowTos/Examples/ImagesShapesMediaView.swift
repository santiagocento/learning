//
//  SwiftUIView.swift
//  HowTos
//
//  Created by Santiago Cento on 28/03/2024.
//

import SwiftUI
import AVKit
import SpriteKit
import PhotosUI

struct ImagesShapesMediaView: View {
    @State private var completionAmount = 0.0
    @State private var iconValue = 0.0
    
    @State private var selectedItem: PhotosPickerItem? // [PhotoPickerItem]() para multiples
    @State private var avatarImage: Image? // [Image]()
    
    @State private var loadState = MovieLoadState.unknown
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common)//.autoconnect() descomentar para que empiece
    var skScene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 100, height: 100)
        scene.scaleMode = .fill
        return scene
    }
    
    @State private var simple = false
    @State private var gradients = false
    @State private var shapes = false
    @State private var other = false
    @State private var sfSymbols = false
    @State private var photoPickers = false
    
    
    var body: some View {
        List {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $simple, label: { Text("Simple") })
                    Toggle(isOn: $gradients, label: { Text("Gradientes") })
                    Toggle(isOn: $shapes, label: { Text("Shapes") })
                    Toggle(isOn: $other, label: { Text("Other") })
                    Toggle(isOn: $sfSymbols, label: { Text("SF Symbols") })
                    Toggle(isOn: $photoPickers, label: { Text("Photo Pickers") })
                }
            }
            if simple {
                // MARK: - Simple
                // Por default las imagenes toman el tamaño propio (ej. 312x312)
                CenteredContainerView {
                    Image("perrito")
                    Image(uiImage: UIImage(named: "perrito")!)
                    Image("perrito")
                        .resizable() // Llena TODO el espacio disponible
                        .frame(height: 75)
                    Image("perrito")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 75)
                    
                    // Tiling
                    Image("perrito")
                        .resizable(resizingMode: .tile) // claramente por default es stretch
                    Image("perrito")
                        .resizable(capInsets: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10), resizingMode: .tile)
                    Divider()
                        .padding()
                    // SF Symbols
                    Image(systemName: "moon.stars.fill")
                    Image(systemName: "wind.snow").font(.largeTitle)
                    Image(systemName: "cloud.heavyrain").font(.largeTitle)
                        .foregroundColor(.red)
                    Image(systemName: "cloud.sun.rain.fill")
                        .renderingMode(.original) // Multi-color mode
                        .font(.largeTitle)
                        .padding()
                        .background(.black)
                        .clipShape(Circle())
                    
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .renderingMode(.original)
                        .foregroundStyle(.blue)
                        .font(.largeTitle)
                    
                    // Se puede usar cualquier cosa como background
                    Text("Este es un perrito")
                        .font(.system(size: 48))
                        .foregroundStyle(.red)
                        .padding()
                        .background(
                            Image("perrito")
                                .resizable()
                        )
                }.padding(.vertical)
            }
            if gradients {
                // MARK: - Shapes
                CenteredContainerView {
                    if #available(iOS 16, *) {
                        Rectangle().fill(.blue.gradient).frame(height: 50)
                        
                        Text("Muestra")
                            .padding()
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                            )
                        
                        Circle()
                            .fill(
                                RadialGradient(gradient:
                                                Gradient(colors: [.red, .yellow, .green, .blue, .purple]),
                                               center: .center, startRadius: 0, endRadius: 50))
                            .frame(width: 100)
                        
                        Circle()
                            .fill(
                                AngularGradient(colors: [.red, .green, .blue, .red], center: .center, startAngle: .zero, endAngle: Angle(degrees: 360))
                            )
                            .frame(width: 100)
                        
                        Circle()
                            .strokeBorder(
                                AngularGradient(colors: [.red, .green, .blue, .red], center: .center, startAngle: .zero, endAngle: Angle(degrees: 360)), lineWidth: 10
                            )
                            .frame(width: 100)
                    }
                }
            }
            if shapes {
                // MARK: - Shapes
                // Simple shapes and borders with extension for ease of use
                CenteredContainerView {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.red)
                        .frame(width: 100, height: 100)
                    Capsule()
                        .fill(.green)
                        .frame(width: 100, height: 50)
                    
                    Circle()
                        .strokeBorder(.red, lineWidth: 10)
                        .background(Circle().fill(.gray))
                        .frame(width: 100, height: 100)
                    
                    ZStack {
                        Circle().fill(.gray)
                        Circle().strokeBorder(.red, lineWidth: 4)
                    }.frame(width: 100, height: 100)
                    
                    Circle()
                        .fill(.gray, strokeBorder: .red, lineWidth: 5)
                        .frame(width: 80, height: 80)
                }
                // Trimming
                CenteredContainerView {
                    Circle()
                        .trim(from: 0.25, to: 0.75)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: completionAmount)
                        .stroke(.red, lineWidth: 10)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                        .onReceive(timer) { _ in
                            withAnimation {
                                if completionAmount >= 1 {
                                    completionAmount = 0
                                } else {
                                    completionAmount += 0.1
                                }
                            }
                        }
                }
            }
            if other {
                // ContainerRelativeShape
                CenteredContainerView {
                    // Insetable version of whatever shape is inside
                    // Solo funciona dentro de un widget
                    ZStack {
                        ContainerRelativeShape()
                            .inset(by: 4)
                            .fill(.blue)
                        
                        Text("Sarasa").font(.largeTitle)
                    }
                    .frame(width: 300, height: 200)
                    .background(.red)
                    .clipShape(Capsule())
                }
                // Video
                CenteredContainerView {
                    VideoPlayer(player: AVPlayer(url: URL(string: "https://bit.ly/swswift")!))
                        .frame(height: 100)
                }
                // SpriteKit
                CenteredContainerView {
                    SpriteView(scene: skScene).frame(width: 100, height: 100).ignoresSafeArea()
                }
                
                // Image from URL
                HStack {
                    // Muestra placeholder por defecto, sea que no se pudo descargar o que fallo o no es valida la url
                    AsyncImage(url: URL(string: "ivalidURL")).frame(width: 80, height: 80)
                    
                    AsyncImage(url: URL(string: "https://hws.dev/paul.jpg")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.red
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    
                    // Por default scale es 1, si ya sabes la escala para que quede bien podes controlarla
                    AsyncImage(url: URL(string: "https://hws.dev/paul.jpg"), scale: 12)
                    
                    // Full control del proceso
                    AsyncImage(url: URL(string: "modificar para ver el comportamiento"), scale: 12) { phase in
                        switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                            case .failure(let error):
                                Text(error.localizedDescription)
                            default:
                                ProgressView()
                        }
                    }.clipShape(RoundedRectangle(cornerRadius: 10))
                    
                }
            }
            if sfSymbols {
                CenteredContainerView {
                    // Rendering mode .original = Multicolor / .hierarchical = Variation in shades / .palette = Complete control
                    Image(systemName: "theatermasks")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 60))
                    
                    Image(systemName: "theatermasks")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 60))
                        .foregroundStyle(.red)
                    
                    Image(systemName: "shareplay")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 60))
                        .foregroundStyle(.red, .gray)
                    
                    // Como se aplica cada color depende de cada simbolo
                    Image(systemName: "person.3.sequence.fill")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 60))
                        .foregroundStyle(.red, .gray, .green)
                    // Tambien funciona con estilos mas complejos
                    Image(systemName: "person.3.sequence.fill")
                        .symbolRenderingMode(.palette)
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing),
                            LinearGradient(colors: [.gray, .white], startPoint: .leading, endPoint: .trailing),
                            LinearGradient(colors: [.green, .white], startPoint: .leading, endPoint: .trailing))
                    // Ajuste dinamico
                    CenteredContainerView {
                        HStack {
                            Image(systemName: "aqi.low", variableValue: iconValue).font(.largeTitle)
                            Image(systemName: "wifi", variableValue: iconValue).font(.largeTitle)
                            Image(systemName: "chart.bar.fill", variableValue: iconValue).font(.largeTitle)
                            Image(systemName: "waveform", variableValue: iconValue).font(.largeTitle)
                        }
                        Slider(value: $iconValue)
                    }
                }
            }
            if photoPickers {
                // MARK: - Photos picker
                CenteredContainerView {
                    // matching: para filtrar tipo de imagenes / .any(of: []) para varios / .not(.videos)
                    PhotosPicker("Select photo", selection: $selectedItem, matching: .images)
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                .onChange(of: selectedItem, { oldValue, newValue in
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                avatarImage = Image(uiImage: uiImage)
                                return
                            }
                        }
                        print("failed")
                    }
                })
                // VIDEO
                CenteredContainerView {
                    PhotosPicker("Select video", selection: $selectedItem, matching: .videos)
                    switch loadState {
                        case .unknown:
                            EmptyView()
                        case .loading:
                            ProgressView()
                        case .loaded(let movie):
                            VideoPlayer(player: AVPlayer(url: movie.url)).scaledToFit().frame(width: 100, height: 100)
                        case .failed:
                            Text("Import Failed")
                    }
                }
                .onChange(of: selectedItem, { oldValue, newValue in
                    Task {
                        do {
                            loadState = .loading
                            
                            if let movie = try await selectedItem?.loadTransferable(type: Movie.self) {
                                loadState = .loaded(movie)
                            } else {
                                loadState = .failed
                            }
                        } catch {
                            loadState = .failed
                        }
                       
                    }
                })
            }
        }
    }
}

struct CenteredContainerView<Content> : View where Content : View {
    @ViewBuilder var item: () -> Content
    
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                item()
            }
            Spacer()
        }
    }
}

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let box = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 20))
        addChild(box)
    }
}

struct Movie: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { recieved in
            let copy = URL.documentsDirectory.appending(path: "movie.mp4")
            
            if FileManager.default.fileExists(atPath: copy.path()) {
                try FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: recieved.file, to: copy)
            return Self.init(url: copy)
        }
    }
}

enum MovieLoadState {
    case unknown, loading, loaded(Movie), failed
}

#Preview {
    ImagesShapesMediaView()
}
