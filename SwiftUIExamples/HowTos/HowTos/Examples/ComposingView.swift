//
//  ComposingView.swift
//  HowTos
//
//  Created by Santi on 26/03/2025.
//

import SwiftUI

struct ComposingView: View {
    
    @State private var text = NSMutableAttributedString(string: "")
    @State private var searchText = ""
    @State private var placeHolder = "Buscar!"
    
    var body: some View {
        VStack {
            EmployeeView()
            
            (Text("SwiftUI ")
                .foregroundColor(.red)
             + Text("is ")
                .foregroundColor(.orange)
                .fontWeight(.black)
             + Text("awesome")
                .foregroundColor(.blue))
            // solo se puede usar modificadores que no cambien el tipo de vista de Text
            // por eso hay que encerrarlos en () para poder ponerle el padding
            .padding()
            
            Text("Goodbye ") + Text(Image(systemName: "star")) + Text(" World!")
                .foregroundColor(.blue)
                .font(.title)
            
            HStack {
                VStack {
                    title
                        .foregroundStyle(.red.mix(with: .orange, by: 0.3))
                    subtitle
                }
                Text("Custom Modifier")
                    .modifier(CustomModifierPrimaryLabel())
            }
            UIKitTextView(text: $text)
                .border(.gray)
                .frame(maxHeight: 100)
            
            UIKitSearchField(text: $searchText)
                .placeholder(placeHolder)
            
            Button("Cambiar placeholder text") {
                // randomize the placeholder every press, to
                // prove this works
                placeHolder = UUID().uuidString
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
    
    // Views as properties
    let title: some View = Text("Santiago Cento")
        .bold()
        .frame(maxWidth: .infinity, alignment: .leading)
    
    let subtitle: some View = Text("Author")
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading)
}

#Preview {
    ComposingView()
}

struct Employee {
    var name: String
    var jobTitle: String
    var emailAddress: String
    var profilePicture: ImageResource
}

struct ProfilePicture: View {
    var imageName: ImageResource
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
    }
}

struct EmailAddress: View {
    var address: String
    
    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(address)
        }
    }
}

struct EmployeeDetails: View {
    var employee: Employee
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(employee.name)
                .font(.title)
                .foregroundStyle(.primary)
            Text(employee.jobTitle)
                .foregroundStyle(.secondary)
            EmailAddress(address: employee.emailAddress)
        }
    }
}

struct EmployeeView: View {
    var employee: Employee = Employee(name: "Santi",
                                      jobTitle: "iOS Dev",
                                      emailAddress: "santi@codertlab.com",
                                      profilePicture: .santi)
    
    var body: some View {
        HStack(spacing: 24) {
            ProfilePicture(imageName: employee.profilePicture)
            EmployeeDetails(employee: employee)
        }
    }
}

struct CustomModifierPrimaryLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.red.mix(with: .orange, by: 0.1))
            .foregroundColor(.white)
            .font(.callout)
            .clipShape(Capsule())
    }
}

struct UIKitTextView: UIViewRepresentable {
    @Binding var text: NSMutableAttributedString
    
    func makeUIView(context: Context) -> UITextView {
        UITextView()
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
}

struct UIKitSearchField: UIViewRepresentable {
    @Binding var text: String
    
    private var placeholder = ""
    
    init(text: Binding<String>) {
        _text = text
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        return searchBar
    }
    
    // Always copy the placeholder text across on update
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
    }
}

// Any modifiers to adjust your search field – copy self, adjust, then return.
// Custom modifier para el bridge de UIKit a SwiftUI
extension UIKitSearchField {
    func placeholder(_ string: String) -> UIKitSearchField {
        var view = self
        view.placeholder = string
        return view
    }
}
