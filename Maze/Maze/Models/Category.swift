//
//  Category.swift
//  Maze
//
//  Created by Janiece Eleonour on 05.09.2024.
//

import SwiftUI

enum MazeCategory: Int, CaseIterable, Identifiable, Codable {
    case rectangularMaze,
         caveMaze, 
         cyclicMaze, 
         keyMaze, 
         teleportMaze, 
         trapMaze, 
         timeMaze, 
         obstacleMaze

    var id: Int { rawValue }

    var name: LocalizedStringKey {
        switch self {
        case .rectangularMaze:
            "Rectangular Maze"
        case .caveMaze:
            "Cave Maze"
        case .cyclicMaze:
            "Cyclic Maze"
        case .keyMaze:
            "Key Maze"
        case .teleportMaze:
            "Teleport Maze"
        case .trapMaze:
            "Trap Maze"
        case .timeMaze:
            "Time Maze"
        case .obstacleMaze:
            "Obstacle Maze"
        }
    }
}
