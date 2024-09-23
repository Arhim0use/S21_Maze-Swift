//
//  CaveGenerator.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 18.09.2024.
//

import Foundation

protocol MazeGenerate {
    var maze: Maze { get set }
    
    func generate()
}

struct CaveConfigurations {
    static let maxNeighbours = 7
    static let minNeighbours = 1
    static let maxCaveField = 50
}

/// maze.lowerWalls - Поле с пещерами
class CaveGenerator: MazeGenerate {
    //    true - wall false - cave
    var maze: Maze
    var repeatCount: UInt16 = 50
    
    private var _birthLimit = 3
    private var _deathLimit = 6
    
    var birthLimit: Int {
        get { return _birthLimit }
        set {
            if newValue < CaveConfigurations.minNeighbours {
                self._birthLimit = CaveConfigurations.minNeighbours
            } else if newValue > CaveConfigurations.maxNeighbours {
                self._birthLimit = CaveConfigurations.maxNeighbours
            } else {
                self._birthLimit = newValue
            }
        }
    }
    
    var deathLimit: Int {
        get { return _deathLimit }
        set {
            if newValue < CaveConfigurations.minNeighbours {
                self._deathLimit = CaveConfigurations.minNeighbours
            } else if newValue > CaveConfigurations.maxNeighbours {
                self._deathLimit = CaveConfigurations.maxNeighbours
            } else {
                self._deathLimit = newValue
            }
        }
    }
    
    init() { self.maze = Maze(col: 10, row: 10) }
    
    init(rows: Int, cols: Int) { self.maze = Maze(col: rows, row: cols) }
    
    init(maze: Maze) { self.maze = maze }
    
    /// CaveGenerator.maze.lowerWalls - Поле с пещерами
    func initCave() {
        for row in 0..<maze.row {
            for col in 0..<maze.col {
                maze.lowerWalls[row][col] = Int.random(in: 0...8) <= birthLimit ? false : true
            }
        }
    }
    
    func generate() {
        var mazeEq = false
        var repeats = 0
        printCave()
        
        repeat {
            step()
            if repeats % 2 == 0 {
                mazeEq = maze.lowerWalls == maze.rightWalls
            }
            maze.lowerWalls = maze.rightWalls
            print(repeats)
            printCave()
            repeats += 1
        } while !mazeEq && repeats < repeatCount
    }
    
    /// CaveGenerator.maze.lowerWalls - Поле с пещерами
    func oneStep() {
        step()
        maze.lowerWalls = maze.rightWalls
    }
    
    private func step() {
        for row in 0..<maze.row {
            for col in 0..<maze.col {
                let neighborsCount = checkNeighbors(row: row, col: col)
                let isLive = maze.lowerWalls[row][col]
                let isDead = !isLive
                
                if isDead && neighborsCount > birthLimit {
                    maze.rightWalls[row][col] = true
                } else if isLive && neighborsCount > deathLimit {
                    maze.rightWalls[row][col] = false
                }
            }
        }
        
    }
    
    private func checkNeighbors(row: Int, col: Int) -> Int {
        var countLiveNeighbors = 0
        for i in -1..<2 {
            for j in -1..<2 {
                if i == 0 && j == 0 { continue }
                if isAliveNeighbor(row: row + i,
                                   col: col + j) {
                    countLiveNeighbors += 1
                }
            }
        }
        return countLiveNeighbors
    }
    
    private func isAliveNeighbor(row: Int, col: Int) -> Bool {
        if row < 0 || row >= maze.row || col < 0 || col >= maze.col {
            return true
        }
        return maze.lowerWalls[row][col]
    }
    
    ///    ⬛️ - wall, ⬜️ - cave
    func caveToString() -> String {
        var cave = ""
        for row in maze.lowerWalls {
            for cell in row {
                cave += cell ? "⬛️" : "⬜️"
            }
            cave += "\n"
        }
        return cave
    }
    
    ///    ⬛️ - wall, ⬜️ - cave
    func printCave() {
        print(caveToString())
    }
}
