//
//  MazeCommands.swift
//  Maze
//
//  Created by Janiece Eleonour on 09.09.2024.
//

import SwiftUI

struct SelectedMazeKey: FocusedValueKey {
    typealias Value = MazeData
}

extension FocusedValues {
    var selectedMaze: SelectedMazeKey.Value? {
        get { self[SelectedMazeKey.self] }
        set { self[SelectedMazeKey.self] = newValue }
    }
}
