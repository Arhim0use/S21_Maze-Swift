//
//  MazeImporter.swift
//  Maze
//
//  Created by Janiece Eleonour on 14.09.2024.
//

import SwiftUI

enum ImportErrorSaver: LocalizedError {
    case parseError(String)
    case fileNotFound(String)
    case invalidData(String)
    
    var errorDescription: String? {
        switch self {
        case .parseError(let message):
            "Parse error: \(message)"
        case .fileNotFound(let fileName):
            "File not found: \(fileName)"
        case .invalidData(let message):
            "Invalid data: \(message)"
        }
    }
}
