//
//  PersonRowApp.swift
//  PersonRow
//
//  Created by Floriano Fraccastoro on 14/02/23.
//

import SwiftUI

@main
struct PersonRowApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
