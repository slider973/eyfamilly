//
//  ContentView.swift
//  EyFamily
//
//  Created by jonathan lemaine on 10/10/2024.
//

import SwiftUI
import FirebaseCore

struct ContentView: View {
    // Créez une instance de FirestoreService ici
    private let firestoreService = FirestoreService()

    var body: some View {
        TabView {
            NavigationView {
                ShoppingListView(firestoreService: firestoreService)
                    .navigationTitle("Shopping List")
            }
            .tabItem {
                Label("Shopping", systemImage: "cart")
            }
            
            NavigationView {
                Text("Calendar View")
                    .navigationTitle("Family Calendar")
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            NavigationView {
                Text("Tasks View")
                    .navigationTitle("Family Tasks")
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            
            NavigationView {
                Text("Settings View")
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
}
