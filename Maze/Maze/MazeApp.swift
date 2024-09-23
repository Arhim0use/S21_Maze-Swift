//
//  MazeApp.swift
//  Maze
//
//  Created by Janiece Eleonour on 03.09.2024.
//

import SwiftData
import SwiftUI

@main
struct MazeApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MazeData.self)
    }
}
