//
//  CaveDraw.swift
//  Maze
//
//  Created by Janiece Eleonour on 21.09.2024.
//

import SwiftUI

struct CaveDraw: View {
    var maze: Maze
    var geometry: GeometryProxy

    var body: some View {
        // Get size of view
        let sizeWidth = min(geometry.size.width, 500)
        let sizeHeight = min(geometry.size.height, 500)
        // Find size of cell
        let cellWidth = sizeWidth / Double(maze.col)
        let cellHeight = sizeHeight / Double(maze.row)

        ForEach(maze.lowerWalls.indices, id: \.self) { i in
            ForEach(maze.lowerWalls[i].indices, id: \.self) { j in
                if maze.lowerWalls[i][j] {
                    Rectangle()
                        .fill(.accent)
                        .frame(width: cellWidth, height: cellHeight)
                        .position(x: cellWidth * (Double(j) + 0.5), y: cellHeight * (Double(i) + 0.5))
                }
            }
        }
    }
}

#Preview {
    MazeDraw(mazeData: MazeData.mazes[2])
}
