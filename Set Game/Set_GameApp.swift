//
//  Set_GameApp.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

@main
struct Set_GameApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: SetGameViewModel())
        }
    }
}
