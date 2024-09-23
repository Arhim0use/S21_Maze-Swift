//
//  MazeGenerator.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 07.09.2024.
//

import Foundation

class MazeGenerator: MazeGenerate {
    var maze: Maze
    private var mazeRow: [Int]
    
    init(maze: Maze) {
        self.maze = maze
        self.mazeRow = Array(1..<maze.col)
    }
    
    init(rows: Int, cols: Int) {
        if rows > 0, cols > 0 {
            self.maze = Maze(col: cols, row: rows)
            self.mazeRow = Array(1...cols)
        } else {
            self.maze = Maze(col: 1, row: 1)
            self.mazeRow = [0]
        }
    }
    
    func generate() {
        if maze.row == 1 {
            soloRowMaze()
            return
        }
        
        for row in 0..<maze.row {
            genVWalls(row)
            genHWalls(row)
            setNextRow(row)
        }
        lastRow()
    }
    
    private func genVWalls(_ row: Int) {
        for i in 0..<mazeRow.count - 1 {
            if Bool.random() && mazeRow[i + 1] != mazeRow[i] {
                maze.rightWalls[row][i] = false
                mergeSet(i)
            }
        }
    }
    
    private func genHWalls(_ row: Int) {
        guard row < maze.row - 1 else { return }
        for i in 0..<mazeRow.count {
            if Bool.random() {
                maze.lowerWalls[row][i] = false
            }
            if maze.rightWalls[row][i] && !isHaveVerticalDoor(row, pos: i) {
                maze.lowerWalls[row][i] = false
            }
        }
    }
        
    private func lastRow() {
        for i in 0..<maze.col - 1 {
            if maze.rightWalls[maze.row - 1][i] && mazeRow[i] != mazeRow[i + 1] {
                maze.rightWalls[maze.row - 1][i] = false
                mergeSet(i)
            }
        }
    }
    
    private func mergeSet(_ pos: Int) {
        let nextNum = mazeRow[pos + 1]
        for i in 0..<mazeRow.count where mazeRow[i] == nextNum {
            mazeRow[i] = mazeRow[pos]
        }
    }
    
    private func setNextRow(_ row: Int) {
        guard row < maze.row - 1 else { return }
        var uniqueNum = (row + 1) * maze.col + 1
        for i in 0..<mazeRow.count {
            if maze.lowerWalls[row][i] {
                mazeRow[i] = uniqueNum
            }
            uniqueNum += 1
        }
    }
    
    private func isHaveVerticalDoor(_ row: Int, pos: Int) -> Bool {
        guard pos != 0 else { return !maze.lowerWalls[row][0] }
        var isDoor = false
        for i in (0...pos).reversed() where mazeRow[i] == mazeRow[pos] {
            isDoor = !maze.lowerWalls[row][i]
            if isDoor { break }
        }
        return isDoor
    }
    
    private func soloRowMaze() {
        if maze.col > 2 {
            for i in 0..<maze.col - 1 {
                maze.rightWalls[0][i] = false
            }
        }
    }
    
    func printMaze() {
        for _ in 0...maze.col {
            let x = "￣￣"
            print(x, terminator: "")
        }
        print("")
        for i in 0..<maze.row {
            for k in 0..<maze.col {
                if i != maze.row && k != maze.col {
                    let hw = maze.lowerWalls[i][k] ? "＿" : "  "
                    let vw = maze.rightWalls[i][k] ? "|" : " "
                    print(hw, vw, separator: "", terminator: "")
                }
            }
            print("")
        }
    }
}   // class MazeGenerator

func genenerateTest() {
    let mazeG = MazeGenerator(rows: 10, cols: 10)
    mazeG.generate()
    mazeG.printMaze()
}
