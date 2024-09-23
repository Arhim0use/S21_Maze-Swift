//
//  ParseGrid.swift
//  Maze
//
//  Created by Chingisbek Anvardinov on 11.09.2024.
//

import Foundation

class ParseGrid {
    let stringData: [String]
    var size: (row: Int, col: Int) = (0, 0)
    
    init(_ stringData: [String]) {
        self.stringData = stringData
    }
    
    public func mazeSize() throws -> (row: Int, col: Int) {
        let tokens = stringData[0].components(separatedBy: " ")
        
        guard tokens.count == 2 else {
            throw ParseError.invalidFormat("Error: Incorrect format of the maze size (\(tokens))")
        }
        
        let size = (try findSize(tokens[0]),
                    try findSize(tokens[1]))
        
        guard size.0 > 0 && size.1 > 0 else {
            let str = size.0 <= 0 ? "rows" : "columns"
            throw ParseError.invalidSize(
                "Error: Incorrect maze size property, \(str) is equal to or less than zero")
        }

        return size
    }
    
    fileprivate func fillRow(_ tokens: [String], _ i: Int, _ mazeRow: inout [Bool]) throws {
        guard tokens.count >= size.col else {
            throw ParseError.invalidMatrix("Error: Missing element in row \(i)")
        }
                
        for k in 0..<size.col {
            let num = validNum(element: tokens[k], ParseMazeConfig.validTrueInMaze)
            switch num {
            case .success(let valid):
                if valid == 1 {
                    mazeRow[k] = true
                } else {
                    mazeRow[k] = false
                }
            case .failure(let e):
                throw ParseError.invalidMatrix(
                    "Error: Incorrect element at position \(i):\(k) (\(e))")
            }
        }
    }
    
    public func parseGrid(mazeRow: inout [[Bool]], fromString: Int, toString: Int) throws {
        guard stringData.count > toString else {
            throw ParseError.invalidFormat("Error: Not enouth data.")
        }
        var k = 0
        for i in fromString...toString {
            if stringData[i].isEmpty  || k >= mazeRow.count { continue }
            let tokens = stringData[i].components(separatedBy: " ")
            try fillRow(tokens, i, &mazeRow[k])
            k += 1
        }
    }
    
    public func validNum(element: String,
                         _ inRangeFromZeroTo: Int) -> Result<Int, ParseError> {
        guard let num = Int(element) else {
            return .failure(ParseError.invalidFormat(element))
        }
        
        switch num {
        case 0...inRangeFromZeroTo:
            return .success(num)
        default:
            return .failure(ParseError.invalidDigit("\(num)"))
        }
    }
    
    private func findSize(_ token: String) throws -> Int {
        let size = validNum(element: token, ParseMazeConfig.maxMazeSize)
        switch size {
        case .success(let num):
            return num
        case .failure(let err):
            throw ParseError.invalidSize("Error: Incorrect size (\(err))")
        }
    }
    
}   // class GridParse
