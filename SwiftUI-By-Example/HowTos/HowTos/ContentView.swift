//
//  ContentView.swift
//  HowTos
//
//  Created by Santiago Cento on 28/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State var bindingValue = 0
    
    var body: some View {
        NavigationStack {
            List {
                Row(name: "Texts", item: TextsView())
                Row(name: "Images, shapes and media", item: ImagesShapesMediaView())
                Row(name: "Layout Views", item: LayoutViews())
                Row(name: "Stacks, Grids and Scrollviews", item: StackGridsScrollviewView())
                Row(name: "User Interface Controls", item: UserInterfaceControlsView())
                Row(name: "Responding To Events", item: RespondingToEventsView())
                Row(name: "Taps and Gestures", item: TapsAndGesturesView())
                Row(name: "Handling State", item: HandlingStateView(bindingValue: $bindingValue, observedObject: ObservableObj()))
            }
            .navigationTitle("Examples")
        }
        .environmentObject(EnvironmentObj())
    }
}

struct Row: View {
    var name: String
    var item: any View

    var body: some View {
        NavigationLink {
            AnyView(item)
                .navigationTitle(name)
                .navigationBarTitleDisplayMode(.large)
        } label: {
            Text(name)
        }
    }
}

#Preview {
    ContentView()
}
