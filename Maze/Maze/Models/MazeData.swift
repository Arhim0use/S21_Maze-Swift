//
//  MazeData.swift
//  MazeData
//
//  Created by Janiece Eleonour on 05.09.2024.
//

import SwiftData
import SwiftUI

@Model
class MazeData: Identifiable {
    var id: UUID
    var name: String
    var imageData: Data?
    var category: MazeCategory
    var rightWalls: [[Bool]]
    var lowerWalls: [[Bool]]
    
    init(id: UUID = UUID(),
         name: String,
         imageData: Data? = nil,
         category: MazeCategory,
         rightWalls: [[Bool]],
         lowerWalls: [[Bool]]) {
        self.id = id
        self.name = name
        self.imageData = imageData
        self.category = category
        self.rightWalls = rightWalls
        self.lowerWalls = lowerWalls
    }
}

extension [MazeData] {
    subscript(mazeID: MazeData.ID?) -> MazeData? {
        guard let mazeID else { return nil }
        var mazesByID: [MazeData.ID: MazeData]?
        if mazesByID == nil {
            mazesByID = Dictionary(
                uniqueKeysWithValues: self.map { ($0.id, $0) })
        }
        return mazesByID![mazeID]
    }
}

extension MazeData {
    var toMaze: Maze {
        Maze(lowerWalls: lowerWalls, rightWalls: rightWalls)
    }
    
    var isEmpty: Bool {
        rightWalls.isEmpty && lowerWalls.isEmpty
    }
}

extension Maze {
    var toMazeData: MazeData {
        MazeData(name: Date.now.description,
                        category: .rectangularMaze,
                        rightWalls: rightWalls,
                        lowerWalls: lowerWalls)
    }
    
    func toMazeData(name: String, category: MazeCategory) -> MazeData {
        .init(name: name, category: category, rightWalls: rightWalls, lowerWalls: lowerWalls)
    }
}

extension MazeData {
    static let mazes = [
        MazeData(name: "MazeData 1", category: .rectangularMaze, rightWalls: [
            [false, false, true, false, false, false, false, true, false, true],
            [false, true, true, true, false, false, false, true, true, true],
            [true, false, true, false, false, true, true, true, true, true],
            [true, false, false, true, false, false, true, false, true, true],
            [false, false, true, false, true, false, true, false, true, true],
            [true, false, false, false, false, true, true, false, true, true],
            [false, false, false, true, true, false, false, true, false, true],
            [false, false, false, false, true, false, true, true, false, true],
            [true, false, false, false, true, true, true, false, false, true],
            [false, true, false, true, false, true, false, false, false, true]
        ], lowerWalls: [
            [false, true, false, false, false, true, true, true, false, false],
            [true, true, false, false, true, true, true, false, false, false],
            [false, false, true, true, true, false, false, false, false, false],
            [false, true, true, false, false, true, false, false, true, false],
            [true, false, true, true, true, false, true, true, true, false],
            [false, true, true, true, false, true, false, false, false, false],
            [true, true, false, true, false, false, true, false, true, true],
            [false, true, true, true, true, false, false, false, true, false],
            [true, false, true, false, false, false, false, true, true, true],
            [true, true, true, true, true, true, true, true, true, true]
        ]),
        MazeData(name: "MazeData 2", category: .rectangularMaze, rightWalls: [
            [true, true, false, false, false, false, true, false, false, true],
            [false, true, false, true, true, true, true, true, true, true],
            [true, false, false, true, false, true, true, false, true, true],
            [true, true, true, false, false, false, true, true, false, true],
            [false, true, false, true, false, false, true, false, true, true],
            [true, false, true, false, true, false, false, true, true, true],
            [true, false, true, true, true, false, false, true, false, true],
            [false, false, false, false, false, true, false, true, true, true],
            [true, true, false, false, true, false, false, true, false, true],
            [false, false, false, true, false, false, false, false, false, true]
        ], lowerWalls: [
            [false, false, false, true, false, true, false, false, true, false],
            [false, true, true, false, false, false, false, false, false, false],
            [false, false, false, true, true, true, false, true, false, false],
            [false, false, true, true, true, true, false, false, false, false],
            [false, false, false, true, false, true, true, false, false, false],
            [false, true, true, false, true, false, true, true, true, false],
            [true, true, false, false, false, true, true, false, false, true],
            [false, true, true, true, true, false, true, false, false, false],
            [false, false, true, true, false, true, true, true, true, false],
            [true, true, true, true, true, true, true, true, true, true]
        ]),
        MazeData(name: "Cave 1", category: .caveMaze, rightWalls: [
            [false, true, false, true],
            [true, false, false, true],
            [false, true, false, false],
            [false, false, true, true]
        ], lowerWalls: [
            [false, true, false, true],
            [true, false, false, true],
            [false, true, false, false],
            [false, false, true, true]

        ])
    ]

}
