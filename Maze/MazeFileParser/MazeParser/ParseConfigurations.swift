//
//  ParseConfigurations.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 11.09.2024.
//

import Foundation

struct ParseMazeConfig {
    static let maxMazeSize = 50
    static let validTrueInMaze = 1
}

enum ParseError: Error {
    case invalidFormat(String)
    case invalidSize(String)
    case invalidMatrix(String)
    case invalidDigit(String)
}
