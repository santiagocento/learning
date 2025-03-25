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
                Row(name: "Handling State", item: HandlingStateView(bindingValue: $bindingValue,
                                                                    bindableValue: BindableObject(),
                                                                    observedObject: ObservableObj()))
                Row(name: "Lists", item: ListsView())
                Row(name: "Forms", item: FormsView())
                Row(name: "Containers", item: NavTabAndGroupBoxView())
                Row(name: "Navigation", item: NavigationExamplesView())
                Row(name: "NavigationSplitViews", item: NavigationSplitViewExamples())
                Row(name: "Alerts and Menus", item: AlertsAndMenusView())
                Row(name: "Presenting Views", item: PresentingView())
                Row(name: "Transofrming Views", item: TransformingView())
                Row(name: "Drawing Views", item: DrawingView())
                Row(name: "Animating Views", item: AnimationsView())
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
