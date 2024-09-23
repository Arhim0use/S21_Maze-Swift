//
//  ParseMaze.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 11.09.2024.
//

import Foundation

protocol Parse {
    func parse() -> Result<Maze, ParseError>
}

class ParseMazeFiles: Parse {
    private var stringData = ""
    var mazeCategory: MazeCategory = .rectangularMaze
    
    init(str: String) {
        self.stringData = str
    }
    
    init(data: Data) {
        guard let str = String(data: data, encoding: .utf8) else { return }
        self.stringData = str
    }
    
    func setData(data: Data) -> Bool {
        guard let str = String(data: data, encoding: .utf8) else { return false }
        self.stringData = str
        return true
    }
    
    func parse() -> Result<Maze, ParseError> {
        guard !stringData.isEmpty else {
            return .failure(ParseError.invalidFormat("Error: Not enouth data."))
        }
        
        let matices = stringData.components(separatedBy: "\n")

        switch mazeCategory {
        case .rectangularMaze:
            return ParseRectangular(matices).parse()
        case .caveMaze:
            return ParseCave(matices).parse()
        default:
            return .failure(ParseError.invalidFormat("Error: Unsupported maze type"))
        }
    }

}   // class ParseFiles

class ParseRectangular: ParseGrid, Parse {
    
    private func swapIfNeed(_ maze: inout Maze) {
        if maze.lowerWalls[size.row - 1] != Array(repeating: true, count: size.col) {
            let tempMatrix = maze.rightWalls
            maze.rightWalls = maze.lowerWalls
            maze.lowerWalls = tempMatrix
        }
    }

    func parse() -> Result<Maze, ParseError> {
        
        var result = Maze(col: 0, row: 0)
        
        do {
            size = try mazeSize()
            result = Maze(col: size.col, row: size.row)
            try parseGrid(mazeRow: &result.rightWalls, fromString: 1, toString: size.row)
            try parseGrid(mazeRow: &result.lowerWalls,
                          fromString: size.row + 1,
                          toString: stringData.count - 1)
        } catch (let e) as ParseError {
            return .failure(e)
        } catch {
            print(error)
        }
        
        return .success(result)
    }

}   // class ParseRectangular

class ParseCave: ParseGrid, Parse {
    
    func parse() -> Result<Maze, ParseError> {
        
        var result = Maze(col: 0, row: 0)
        
        do {
            size = try mazeSize()
            result = Maze(col: size.col, row: size.row)
            try parseGrid(mazeRow: &result.rightWalls, fromString: 1, toString: size.row)
        } catch (let e) as ParseError {
            return .failure(e)
        } catch {
            print(error)
        }
        
        return .success(result)
    }
    
}   // class ParseCaves
