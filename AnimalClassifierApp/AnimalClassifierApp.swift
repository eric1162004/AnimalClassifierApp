//
//  AnimalClassifierAppApp.swift
//  AnimalClassifierApp
//
//  Created by eric on 2022-02-20.
//

import SwiftUI

@main
struct AnimalClassifierApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: AnimalModel())
        }
    }
}
