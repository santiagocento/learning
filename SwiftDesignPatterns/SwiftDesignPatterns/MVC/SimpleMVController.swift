//
//  SimpleMVController.swift
//  SwiftDesignPatterns
//
//  Created by Santiago Cento on 20/06/2024.
//

import UIKit
import SwiftUI

final class SimpleMVController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "Este es un ejemplo de MVC común como el que usan todos los devs iOS"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}

struct SimpleMVControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SimpleMVController {
        return SimpleMVController()
    }
    
    func updateUIViewController(_ uiViewController: SimpleMVController, context: Context) {
        // No need to update anything for now
    }
}

#Preview {
    SimpleMVController()
}
