//
//  MazeModel.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 05.09.2024.
//

import Foundation

struct Maze {
    var lowerWalls: [[Bool]]
    var rightWalls: [[Bool]]
    private var _col: Int
    private var _row: Int
    
    var col: Int {
        get { return _col }
        set {
            guard newValue > 0, newValue != _col else { return }
            self._col = newValue
            
            self.lowerWalls = resizeMatrix(newCols: _col, newRows: _row, matrix: lowerWalls)
            self.rightWalls = resizeMatrix(newCols: _col, newRows: _row, matrix: rightWalls)
        }
    }
    
    var row: Int {
        get { return _row }
        set {
            guard newValue > 0, newValue != _row else { return }
            self._row = newValue
            
            self.lowerWalls = resizeMatrix(newCols: _col, newRows: _row, matrix: lowerWalls)
            self.rightWalls = resizeMatrix(newCols: _col, newRows: _row, matrix: rightWalls)
        }
    }
    
    init(lowerWalls: [[Bool]] = [], rightWalls: [[Bool]] = []) {
        self._col = lowerWalls.first?.count ?? 0
        self._row = rightWalls.count
        self.lowerWalls = lowerWalls
        self.rightWalls = rightWalls
    }
    
    init(col: Int, row: Int) {
        self._col = col
        self._row = row
        self.lowerWalls = Array(repeating: Array(repeating: true, count: _col), count: _row)
        self.rightWalls = Array(repeating: Array(repeating: true, count: _col), count: _row)
    }
    
    init() {
        self._col = 0
        self._row = 0
        self.lowerWalls = [[]]
        self.rightWalls = [[]]
    }
    
    private func resizeMatrix(newCols: Int, newRows: Int, matrix: [[Bool]]) -> [[Bool]] {
        var newMatrix: [[Bool]] = Array(repeating: Array(repeating: false, count: newCols),
                                        count: newRows)
        for (i, row) in matrix.enumerated() {
            for (k, element) in row.enumerated() {
                if i < newRows && k < newCols {
                    newMatrix[i][k] = element
                }
            }
        }
        return newMatrix
    }
    
    func printBothMatrix() {
        print("horizontal")
        printMatrix(lowerWalls)
        print("\nvertical")
        printMatrix(rightWalls)
    }
    
    func printMatrix(_ matrix: [[Bool]]) {
        for row in matrix {
            for element in row {
                print(element ? 1 : 0, terminator: " ")
            }
            print("")
        }
    }
}    // struct Maze
