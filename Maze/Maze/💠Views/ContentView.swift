//
//  ContentView.swift
//  Maze
//
//  Created by Janiece Eleonour on 03.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var mazeNavigationModel = MazeNavigationModel()
    
    var body: some View {
        MazeNavigation(mazeNavigationModel: mazeNavigationModel)
            .environment(mazeNavigationModel)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
    ContentView()
}
