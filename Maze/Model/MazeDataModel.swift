//
//  MazeDataModel.swift
//  Maze
//
//  Created by Janiece Eleonour on 21.09.2024.
//

import SwiftUI
import Observation

@Observable final class MazeDataModel {
    private var mazes: [MazeData] = []
    private var mazesByID: [MazeData.ID: MazeData]?

    init(mazes: [MazeData]) {
        self.mazes = mazes
    }
    
    func mazes(in category: MazeCategory?) -> [MazeData] {
        mazes
            .filter { $0.category == category }
            .sorted { $0.name < $1.name }
    }

    func mazes(relatedTo maze: MazeData) -> [MazeData] {
        mazes
            .sorted { $0.name < $1.name }
    }

    subscript(mazeID: MazeData.ID?) -> MazeData? {
        guard let mazeID else { return nil }
        if mazesByID == nil {
            mazesByID = Dictionary(
                uniqueKeysWithValues: mazes.map { ($0.id, $0) })
        }
        return mazesByID![mazeID]
    }

    var mazeOfTheDay: MazeData {
        mazes[0]
    }
}
