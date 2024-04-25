//
//  TextsView.swift
//  HowTos
//
//  Created by Santiago Cento on 28/03/2024.
//

import SwiftUI

struct TextsView: View {
    @State private var name = "Santi"
    @State private var redactingReason = RedactingReasons.invalidated
    let redactingReasons: [RedactingReasons] = [.invalidated, .placeholder, .privacy]
    // mostrar ejemplos sobre estos temas
    @State private var common = false
    @State private var attributedString = false
    @State private var structuredInformation = false
    @State private var formattedView = false
    @State private var label = false
    @State private var placeholdersYMarkdown = false
    @State private var linksYTextSelect = false
    
    var body: some View {
        List {
            VStack {
                LazyVGrid(columns: [GridItem(), GridItem()])  {
                    Toggle(isOn: $common, label: { Text("Common") })
                    Toggle(isOn: $attributedString, label: { Text("Attributed Strings") })
                    Toggle(isOn: $structuredInformation, label: { Text("Structured Info") })
                    Toggle(isOn: $formattedView, label: { Text("Formatted View") })
                    Toggle(isOn: $label, label: { Text("Labels") })
                    Toggle(isOn: $placeholdersYMarkdown, label: { Text("Placeholders y MD") })
                    Toggle(isOn: $linksYTextSelect, label: { Text("Links / Select text") })
                }
            }
            if common {
                //MARK: - Common
                Text("Simple")
                
                Text("This is always 2 lines")
                    .lineLimit(2, reservesSpace: true)
                
                Text("Sample large title")
                    .font(.largeTitle)
                
                Text("Foreground Style simple")
                    .foregroundStyle(.red)
                
                Text("Foreground Style complex")
                    .frame(width: 200)
                    .font(.title)
                    .foregroundStyle(.blue.gradient)
                
                Text("With Background")
                    .padding()
                    .background(.brown)
                    .foregroundStyle(.white)
                
                Text("Texto largo para demostrar linespacing de 30")
                    .lineSpacing(30)
                
                Text("Font design serif")
                    .fontDesign(.serif)
                
                Text("FontWidth condensed")
                    .fontWidth(.condensed)
                
                // 2 modificadores de espaciado de caracteres tracking y kerning
                Text("Tracking text")
                    .tracking(15)
                Text("Kerning text")
                    .kerning(15)
                
                Text("Truncation mode middle: " + Variables.loremIpsum)
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Text(Variables.loremIpsum)
                    .multilineTextAlignment(.center)
                
                Text("Line limit range: " + Variables.loremIpsum)
                    .lineLimit(3...6)
            }
            
            if attributedString {
                //MARK: - Attributed Strings
                // Customization belongs to the string and not the Text view
                
                Text(Variables.attributedString)
                
                Text(Variables.attributedString + " " + Variables.attributedString2)
                
                Text(Variables.underline)
                
                Text(Variables.complex)
                
                Text(Variables.link)
                
                // Con este ejemplo se puede ver como se configura la accesibilidad del string
                // para que lea los caracteres de la contraseña uno por uno
                // de esta manera no hay que tocar nada de la vista
                Text(Variables.passwordAcc)
            }
            
            if structuredInformation {
                // MARK: - Structured information
                // Dar estilo de forma semantica
                // Locale and Language independent
                
                Text(Variables.date)
                
                Text(Variables.name)
                
                Text(Variables.measurments)
            }
            
            if formattedView {
                // MARK: - Format inside text views
                Text(Variables.arrayListStrings, format: .list(type: .and))
                
                Text([6,5,3,7], format: .list(memberStyle: .number, type: .and))
                
                Text(Measurement(value: 226, unit: UnitSpeed.metersPerSecond), format: .measurement(width: .wide))
                
                Text(72.6, format: .currency(code: "USD"))
                
                //MARK: - Fechas
                HStack(alignment: .center) {
                    VStack(alignment: .center) {
                        //Intervalo Fecha
                        Text(Date.now...Date.now.addingTimeInterval(600))
                        //Solo Fecha
                        Text(Date.now.addingTimeInterval(500), style: .date)
                        //Solo hora
                        Text(Date.now.addingTimeInterval(500), style: .time)
                        // tiempo relativo desde el ahora, se actualiza automaticamente
                        Text(Date.now.addingTimeInterval(500), style: .relative)
                        // onda timer, se actualiza automaticamente
                        Text(Date.now.addingTimeInterval(500), style: .timer)
                    }
                    .frame(width: 500)
                }
                
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.uppercase)
                    .padding(.horizontal)
            }
            
            if label {
                //MARK: - Label
                
                HStack {
                    VStack {
                        Label("Your Account", systemImage: "folder.circle")
                        Label("Perrito", image: "perrito")
                        Label("Your Account", systemImage: "person.crop.circle").font(.title)
                        
                        Label("Text Only", systemImage: "heart").labelStyle(.titleOnly)
                        Label("Icon Only", systemImage: "star").labelStyle(.iconOnly)
                        Label("Both", systemImage: "paperplane").labelStyle(.titleAndIcon)
                        
                        Label {
                            Text(name).padding().background(.gray.opacity(0.2)).clipShape(Capsule())
                        } icon: {
                            RoundedRectangle(cornerRadius: 10).fill(.red).frame(width: 32, height: 32)
                        }
                    }.frame(width: 600,alignment: .center)
                }
            }
            
            if placeholdersYMarkdown {
                //MARK: - Placeholders / Redaction Reasons
                //Additive process
                //Tambien funciona en imagenes
                Text("Placeholder text").redacted(reason: .placeholder)
                Text("Otro Placeholder text pero mucho mucho mas largo").redacted(reason: .placeholder)
                
                //Funciona en container
                VStack {
                    Text("Placeholder text")
                    Text("Otro Placeholder text")
                }.redacted(reason: .placeholder)
                
                VStack(alignment: .center) {
                    switch redactingReason {
                        case .invalidated:
                            Text("Invalidated...").redacted(reason: .invalidated)
                        case .placeholder:
                            Text("Placeholder...").redacted(reason: .placeholder)
                        case .privacy:
                            Text("Privacy...").redacted(reason: .privacy)
                    }
                    Picker("Cambiar Reasons", selection: $redactingReason) {
                        ForEach(redactingReasons, id: \.self) { reason in
                            Text(String(describing: reason))
                        }
                    }.pickerStyle(.segmented)
                }
                
                //MARK: - Markdown
                VStack(alignment: .center) {
                    Text("This is regular text.")
                    Text("* This is **bold** text, this is *italic* text, and this is ***bold, italic*** text.")
                    Text("~~A strikethrough example~~")
                    Text("`Monospaced works too`")
                    Text("Visit Apple: [click here](https://apple.com)").tint(.red)
                    //NO SOPORTA IMAGENES
                    Text("![perrito](perrito.png)")
                    // Funciona porque SwiftUI toma el string como un LocalizedStringKey
                    // Usar ese si se quiere almacenar en variable
                    Text(Variables.markdownText)
                    //Usar verbatim para ingnorar simbolos de markdown o localizacion
                    Text(verbatim: "~~sarasa~~")
                }.multilineTextAlignment(.center)
            }
            
            if linksYTextSelect {
                //MARK: - Links
                //Use .discarded if you mean you weren’t able to handle the link.
                //Use .systemAction if you want to trigger the default behavior, perhaps in addition to your own logic.
                //Use .systemAction(someOtherURL) if you want to open a different URL using the default behavior, perhaps a modified version of the URL that was originally triggered.
                VStack(alignment: .leading) {
                    Link("Ir a Apple.com", destination: URL(string: "https://apple.com")!)
                    Text("[Ir pero con markdown](https://apple.com)")
                }
                .environment(\.openURL, OpenURLAction(handler: Variables.handleURL))
                
                //MARK: - Text Select
                Text("Can't touch this")
                Text("Break it down!")
                    .textSelection(.enabled)
                
                VStack (spacing: 20){
                    Text("Can touch this")
                    Text("And this also")
                }
                .textSelection(.enabled)
            }
        }
        .padding()
    }
}


enum RedactingReasons: String, CaseIterable, Hashable {
    case invalidated
    case placeholder
    case privacy
}

private struct Variables {
    
    static let loremIpsum: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    static var attributedString: AttributedString {
        var result = AttributedString("Sample")
        result.foregroundColor = .white
        result.backgroundColor = .blue
        result.font = .title
        return result
    }
    
    
    static var attributedString2: AttributedString {
        var result = AttributedString("Other Sample")
        result.foregroundColor = .black
        result.backgroundColor = .red
        return result
    }
    
    static var underline: AttributedString {
        var result = attributedString
        result.underlineStyle = Text.LineStyle(pattern: .dot, color: .white)
        return result
    }
    
    static var complex: AttributedString {
        let string = "the letters go up and down"
        var result = AttributedString()
        
        for (index, letter) in string.enumerated() {
            var letterString = AttributedString(String(letter))
            let number = sin(Double(index)) * 5
            letterString.baselineOffset = number
            letterString.backgroundColor = UIColor(red: number, green: -number, blue: -number, alpha: 0.5)
            result += letterString
        }
        
        result.font = .largeTitle
        return result
    }
    
    static var link: AttributedString {
        var result = AttributedString("click here")
        result.font = .largeTitle
        result.link = URL(string: "https://codertlab.com.ar")
        return result
    }
    
    static var passwordAcc: AttributedString {
        var password = AttributedString("abCayer=muQai")
        password.accessibilitySpeechSpellsOutCharacters = true
        return "Your password is: " + password
    }
    
    static var date: AttributedString {
        var date = Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide).attributed)
        date.foregroundColor = .red
        
        let weekday = AttributeContainer.dateField(.weekday)
        let weekdayStyling = AttributeContainer.foregroundColor(.blue)
        
        date.replaceAttributes(weekday, with: weekdayStyling)
        return date
    }
    
    static var name: AttributedString {
        var components = PersonNameComponents()
        components.givenName = "Taylor"
        components.familyName = "Swift"
        
        var result = components.formatted(.name(style: .long).attributed)
        
        let familyNameStyling = AttributeContainer.font(.headline).foregroundColor(.red)
        let familyName = AttributeContainer.personNameComponent(.familyName)
        
        result.replaceAttributes(familyName, with: familyNameStyling)
        
        return result
    }
    
    static var measurments: AttributedString {
        let amount = Measurement(value: 200, unit: UnitLength.kilometers)
        
        var result = amount.formatted(.measurement(width: .wide).attributed)
        
        let distanceStyling = AttributeContainer.font(.headline).foregroundColor(.red)
        let distance = AttributeContainer.measurement(.value)
        
        result.replaceAttributes(distance, with: distanceStyling)
        
        return result
    }
    
    static let arrayListStrings = ["Egg", "Sausage", "Bacon", "Spam"]
    
    static let markdownText: LocalizedStringKey = "*This is **bold** text, this is *italic* text, and this is ***bold, italic*** text."
    
    static func handleURL(_ url: URL) -> OpenURLAction.Result {
        print("se handleo \(url) de alguna manera")
        return .handled
    }
}


#Preview {
    TextsView()
}
