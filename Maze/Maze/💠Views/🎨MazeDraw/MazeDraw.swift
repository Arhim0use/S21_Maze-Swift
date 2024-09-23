//
//  MazeDraw.swift
//  Maze
//
//  Created by Janiece Eleonour on 10.09.2024.
//

import SwiftUI

struct MazeDraw: View {
    var mazeData: MazeData
    
    @State private var scale: CGFloat = 1.0
    @State private var showLines = false
    
    var body: some View {
        if !mazeData.isEmpty {
            GeometryReader { geometry in
                switch mazeData.category {
                case .rectangularMaze:
                    RectangularDraw(maze: mazeData.toMaze, geometry: geometry)
                case .caveMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .cyclicMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .keyMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .teleportMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .trapMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .timeMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                case .obstacleMaze:
                    CaveDraw(maze: mazeData.toMaze, geometry: geometry)
                }
            }
            .opacity(showLines ? 1 : .zero)
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value.magnitude
                    }
                    .onEnded { _ in
                        scale = 1
                    }
            )
            .onAppear {
                withAnimation {
                    showLines = true
                }
            }
        }
    }
}

#Preview {
    MazeDraw(mazeData: MazeData.mazes.first!)
}
