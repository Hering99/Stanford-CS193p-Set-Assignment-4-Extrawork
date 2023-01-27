//
//  SetApp.swift
//  Set
//
//  Created by Lukas Hering on 13.12.22.
//

import SwiftUI

@main
struct SetApp: App {
    let game = GameOfSet()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
