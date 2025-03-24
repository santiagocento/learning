//
//  DrawingView.swift
//  HowTos
//
//  Created by Santi on 23/03/2025.
//

import SwiftUI

struct DrawingView: View {
    @Environment(\.displayScale) var displayScale
    
    @State private var shapes = false
    @State private var pathsAndPdfs = true
    
    @StateObject private var storm = Storm()
    let rainColor = Color(red: 0.25, green: 0.5, blue: 0.75)
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                Toggle("Shapes", isOn: $shapes)
                Toggle("Paths and Pdfs", isOn: $pathsAndPdfs)
            }
            .gridCellColumns(2)
            
            ScrollView(showsIndicators: false) {
                if shapes {
                    ZStack {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 220, height: 120)
                        
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.red)
                            .frame(width: 210, height: 110)
                        
                        Capsule()
                            .fill(.green)
                            .frame(width: 200, height: 100)
                        
                        Ellipse()
                            .fill(.blue)
                            .frame(width: 190, height: 90)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 100, height: 50)
                    }
                    
                    // Crear nuestras propias shapes con el protocolo Shape
                    ShrinkingSquares()
                        .stroke(.teal, lineWidth: 5)
                        .background(.blue)
                        .frame(width: 300, height: 100)
                    HStack {
                        Star(corners: 5, smoothness: 0.4)
                            .fill(.teal)
                            .frame(width: 100, height: 100)
                        Star(corners: 3, smoothness: 1)
                            .fill(.teal)
                            .frame(width: 100, height: 100)
                    }
                    Checkerboard(rows: 8, columns: 16)
                        .fill(.teal)
                        .frame(width: 200, height: 100)
                }
                
                if pathsAndPdfs {
                    ScaledBezier(bezierPath: .logo)
                        .stroke(lineWidth: 2)
                        .frame(width: 200, height: 200)
                    
                    ShareLink("Exportar",
                              item: Image(uiImage: renderViewAsImage()),
                              preview: SharePreview(Text("Preview"),
                                                    image: Image(uiImage: renderViewAsImage())))
                    ZStack {
                        Image(.perrito)
                            .resizable()
                            .frame(height: 100)
                        Text("Sarasa blureada")
                            .padding()
                            .background(.ultraThinMaterial)
                    }
                    
                    // Canvas nos da control total sobre que se dibuja en la pantalla
                    // TimelineView nos deja controlar los redraws
                    // En conjunto se pueden usar para hacer animaciones de particulas
                    TimelineView(.animation) { timeline in
                        Canvas { context, size in
                            storm.update(to: timeline.date)
                            
                            for drop in storm.drops {
                                let age = timeline.date.distance(to: drop.removalDate)
                                let rect = CGRect(x: drop.x * size.width, y: size.height - (size.height * age * drop.speed), width: 2, height: 20)
                                let shape = Capsule().path(in: rect)
                                context.fill(shape, with: .color(rainColor))
                            }
                        }
                    }
                    .background(.black)
                    .frame(height: 400)
                }
            }
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        }
        .padding()
    }
    
    // por defecto renderiza en 1x, en pantallas 2x o 3x se va a ver choto
    @MainActor // no usar fuera del main actor
    func renderViewAsImage() -> UIImage {
        let renderer = ImageRenderer(content: Text("Text view as image"))
        renderer.scale = displayScale
        if let uiimage = renderer.uiImage {
            // usar la imagen de alguna manera
            return uiimage
        }
        return UIImage()
    }
    
    // Todo permanece como vectores, asi que va a escalar con cualquier pantalla
    @MainActor
    func renderViewAsPdf() -> URL {
        // Decidir que vista convertir
        let renderer = ImageRenderer(content: Text("Text view as image"))
        // url donde guardar la data de la imagen
        let url = URL.documentsDirectory.appending(path: "output.pdf")
        
        // Comenzar renderizado
        renderer.render { size, context in
            // le indicamos el tamaño (va a ser el mismo que el tamaño de la vista que rendericemos usando size)
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            // crear CGContext para las paginas del pdf
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else { return }
            // empezamos una nueva pagina del pdf
            pdf.beginPDFPage(nil)
            // renderizamos la vista en la pagina
            context(pdf)
            // terminamos la pagina y cerramos el archivo
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
}

#Preview {
    DrawingView()
}

struct ShrinkingSquares: Shape {
    // Unico requerimiento
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for i in stride(from: 1, through: 200, by: 10.0) {
            let rect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            let insetRect = rect.insetBy(dx: i, dy: i)
            path.addRect(insetRect)
        }
        
        return path
    }
}

struct Star: Shape {
    // store how many corners the star has, and how smooth/pointed it is
    let corners: Int
    let smoothness: Double
    
    func path(in rect: CGRect) -> Path {
        // ensure we have at least two corners, otherwise send back an empty path
        guard corners >= 2 else { return Path() }
        
        // draw from the center of our rectangle
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        // start from directly upwards (as opposed to down or to the right)
        var currentAngle = -CGFloat.pi / 2
        
        // calculate how much we need to move with each star corner
        let angleAdjustment = .pi * 2 / Double(corners * 2)
        
        // figure out how much we need to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        
        // we're ready to start with our path now
        var path = Path()
        
        // move to our initial position
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        
        // track the lowest point we draw to, so we can center later
        var bottomEdge: Double = 0
        
        // loop over all our points/inner points
        for corner in 0..<corners * 2  {
            // figure out the location of this point
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: Double
            
            // if we're a multiple of 2 we are drawing the outer edge of the star
            if corner.isMultiple(of: 2) {
                // store this Y position
                bottom = center.y * sinAngle
                
                // …and add a line to there
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                // we're not a multiple of 2, which means we're drawing an inner point
                
                // store this Y position
                bottom = innerY * sinAngle
                
                // …and add a line to there
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }
            
            // if this new bottom point is our lowest, stash it away for later
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            
            // move on to the next corner
            currentAngle += angleAdjustment
        }
        
        // figure out how much unused space we have at the bottom of our drawing rectangle
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        
        // create and apply a transform that moves our path down by that amount, centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}

struct Checkerboard: Shape {
    let rows: Int
    let columns: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)
        
        // loop over all rows and columns, making alternating squares colored
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}


extension UIBezierPath {
    /// The Unwrap logo as a Bezier path.
    static var logo: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.534, y: 0.5816))
        path.addCurve(to: CGPoint(x: 0.1877, y: 0.088), controlPoint1: CGPoint(x: 0.534, y: 0.5816), controlPoint2: CGPoint(x: 0.2529, y: 0.4205))
        path.addCurve(to: CGPoint(x: 0.9728, y: 0.8259), controlPoint1: CGPoint(x: 0.4922, y: 0.4949), controlPoint2: CGPoint(x: 1.0968, y: 0.4148))
        path.addCurve(to: CGPoint(x: 0.0397, y: 0.5431), controlPoint1: CGPoint(x: 0.7118, y: 0.5248), controlPoint2: CGPoint(x: 0.3329, y: 0.7442))
        path.addCurve(to: CGPoint(x: 0.6211, y: 0.0279), controlPoint1: CGPoint(x: 0.508, y: 1.1956), controlPoint2: CGPoint(x: 1.3042, y: 0.5345))
        path.addCurve(to: CGPoint(x: 0.6904, y: 0.3615), controlPoint1: CGPoint(x: 0.7282, y: 0.2481), controlPoint2: CGPoint(x: 0.6904, y: 0.3615))
        return path
    }
}


struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)
        
        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let multiplier = min(rect.width, rect.height)
        
        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        
        // Apply that scale and send back the result.
        return path.applying(transform)
    }
}

struct Raindrop: Hashable, Equatable {
    var x: Double
    var removalDate: Date
    var speed: Double
}

class Storm: ObservableObject {
    var drops = Set<Raindrop>()
    
    func update(to date: Date) {
        drops = drops.filter { $0.removalDate > date }
        drops.insert(Raindrop(x: Double.random(in: 0...1), removalDate: date + 1, speed: Double.random(in: 1...2)))
    }
}
