//
//  SimpleMVController.swift
//  SwiftDesignPatterns
//
//  Created by Santiago Cento on 21/06/2024.
//

import UIKit
import SwiftUI

final class FixedMVController: UIViewController {
    
    let child = ChildFixedMVController()
    var aEa: Observable?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        add(child)
        child.handleConstraints(parent: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        child.remove()
    }
}

final class ChildFixedMVController: UIViewController {
     
    // Forma correcta de hacer UI Programatica
    override func loadView() {
        view = FixedMVCLabel()
    }
    
    func handleConstraints(parent: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 50),
            view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -50)
        ])
    }
}

final class FixedMVCLabel: UILabel {
    // Forma correcta de hacer UI Programatica
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Este es un ejemplo de MVC mejorado, donde se dividen los controladores por vistas, utilizando \"view controller containment\""
        textColor = .black
        textAlignment = .center
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

struct FixedMVControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FixedMVController {
        return FixedMVController()
    }
    
    func updateUIViewController(_ uiViewController: FixedMVController, context: Context) {
        // No need to update anything
    }
}

// Extension para realizar el proceso mas facil. @nonobjc para que no entre en conflicto con ningun codigo de Apple
// Conviene dividir los view controllers por funcionalidad
@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child) // Añade el controlador hijo al controlador principal.
        
        if let frame = frame {
            child.view.frame = frame
        }
        view.addSubview(child.view)
        child.didMove(toParent: self) // Notifica al controlador hijo que ha sido movido a un controlador padre.
    }
    
    func remove() {
        willMove(toParent: nil) // Notifica al controlador hijo que está a punto de ser eliminado de su controlador padre.
        view.removeFromSuperview() // Elimina la vista del controlador hijo de su supervista.
        removeFromParent() // Elimina el controlador hijo del controlador padre
    }
}

#Preview {
    FixedMVController()
}
