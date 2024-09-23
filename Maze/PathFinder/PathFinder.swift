//
//  Direction.swift
//  Maze
//
//  Created by Melania Dababi on 9/6/24.
//

import Foundation

extension CGPoint {
    var iRow: Int {
        get { Int(y) }
        set { y = Double(newValue)}
    }
    var jCol: Int {
        get { Int(x) }
        set { x = Double(newValue)}
    }
}

extension Int {
    var down: Int { self + 1 }
    var upward: Int { self - 1 }
    var left: Int { self - 1 }
    var right: Int { self + 1 }
}

extension Maze {
    private func isPointIntoMaze(_ point: CGPoint) -> Bool {
        point.iRow >= 0 && point.iRow < row && point.jCol >= 0 && point.jCol < col
    }
    
    private func updateCell(value: Int, cell: Int) -> Int {
        cell == -1 ? value : min(cell, value)
    }
    
    private func explorePossibleSteps(step: Int, field: inout [[Int]]) -> Int {
        var result = 0
        
        for i in 0..<row {
            for j in 0..<col where field[i][j] == step {
                result += 1
                if i < row.upward && lowerWalls[i][j] == false {
                    field[i.down][j] = updateCell(value: step.right, cell: field[i.down][j])
                }
                if i > 0 && lowerWalls[i.upward][j] == false {
                    field[i.upward][j] = updateCell(value: step.right, cell: field[i.upward][j])
                }
                if j < col.left && rightWalls[i][j] == false {
                    field[i][j.right] = updateCell(value: step.right, cell: field[i][j.right])
                }
                if j > 0 && rightWalls[i][j.left] == false {
                    field[i][j.left] = updateCell(value: step.right, cell: field[i][j.left])
                }
            }
        }
        
        return result
    }
    
    public func findPath(from start: CGPoint, to end: CGPoint) -> [CGPoint] {
        var field = Array(repeating: Array(repeating: -1, count: col), count: row)
        guard !field.isEmpty, isPointIntoMaze(start), isPointIntoMaze(end) else { return [] }
        
        var route = [CGPoint]()
        var jCol = end.jCol
        var iRow = end.iRow
        var count = 1
        var step = 0
        
        field[start.iRow][start.jCol] = 0
        
        while count > 0 && field[iRow][jCol] == -1 {
            count = explorePossibleSteps(step: step, field: &field)
            step += 1
        }
        
        if field[iRow][jCol] != -1 {
            step = field[iRow][jCol]
            route.append(CGPoint(x: Double(jCol) + 0.5, y: Double(iRow) + 0.5))
            
            while iRow != start.iRow || jCol != start.jCol {
                if iRow < row.upward
                    && lowerWalls[iRow][jCol] == false
                    && field[iRow.down][jCol] == step.left {
                    iRow += 1
                } else if iRow > 0
                            && lowerWalls[iRow.upward][jCol] == false
                            && field[iRow.upward][jCol] == step.left {
                    iRow -= 1
                } else if jCol < col.left
                            && rightWalls[iRow][jCol] == false
                            && field[iRow][jCol.right] == step.left {
                    jCol += 1
                } else if jCol > 0
                            && rightWalls[iRow][jCol.left] == false
                            && field[iRow][jCol.left] == step.left {
                    jCol -= 1
                }
                route.append(CGPoint(x: Double(jCol) + 0.5, y: Double(iRow) + 0.5))
                step -= 1
            }
        }
        return route
    }
}
