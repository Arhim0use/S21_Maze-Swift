//
//  MazeTests.swift
//  MazeTests
//
//  Created by Janiece Eleonour on 22.09.2024.
//

import XCTest
@testable import Maze

final class MazeTests: XCTestCase {
    // MARK: Find path tests
    
    func testFindPathEmptyMaze() {
        let maze = Maze(col: 0, row: 0)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: 0)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [])
    }

    func testFindPathSingleCellMaze() {
        let maze = Maze(col: 1, row: 1)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: 0)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [CGPoint(x: 0.5, y: 0.5)])
    }

    func testFindPathNoPath() {
        var maze = Maze(col: 2, row: 2)
        maze.lowerWalls[0][0] = true
        maze.lowerWalls[0][1] = true
        maze.rightWalls[0][0] = true
        maze.rightWalls[1][0] = true
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 1, y: 1)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [])
    }

    func testFindPathHorizontalPath() {
        var maze = Maze(col: 2, row: 1)
        maze.rightWalls[0][0] = false
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 1, y: 0)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [CGPoint(x: 1.5, y: 0.5), CGPoint(x: 0.5, y: 0.5)])
    }

    func testFindPathVerticalPath() {
        var maze = Maze(col: 1, row: 2)
        maze.lowerWalls[0][0] = false
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: 1)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [CGPoint(x: 0.5, y: 1.5), CGPoint(x: 0.5, y: 0.5)])
    }

    func testFindPathDiagonalPath() {
        var maze = Maze(col: 2, row: 2)
        maze.lowerWalls[0][0] = false
        maze.lowerWalls[0][1] = false
        maze.rightWalls[0][0] = false
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 1, y: 1)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [
            CGPoint(x: 1.5, y: 1.5),
            CGPoint(x: 1.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5)])
    }
    
    func testFindPathTemplateMaze() {
        let maze = MazeData.mazes.first!.toMaze
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 9, y: 9)
        let path = maze.findPath(from: start, to: end)
        XCTAssertEqual(path, [
            CGPoint(x: 9.5, y: 9.5),
            CGPoint(x: 8.5, y: 9.5),
            CGPoint(x: 7.5, y: 9.5),
            CGPoint(x: 6.5, y: 9.5),
            CGPoint(x: 6.5, y: 8.5),
            CGPoint(x: 6.5, y: 7.5),
            CGPoint(x: 5.5, y: 7.5),
            CGPoint(x: 5.5, y: 6.5),
            CGPoint(x: 6.5, y: 6.5),
            CGPoint(x: 7.5, y: 6.5),
            CGPoint(x: 7.5, y: 5.5),
            CGPoint(x: 8.5, y: 5.5),
            CGPoint(x: 8.5, y: 6.5),
            CGPoint(x: 9.5, y: 6.5),
            CGPoint(x: 9.5, y: 5.5),
            CGPoint(x: 9.5, y: 4.5),
            CGPoint(x: 9.5, y: 3.5),
            CGPoint(x: 9.5, y: 2.5),
            CGPoint(x: 9.5, y: 1.5),
            CGPoint(x: 9.5, y: 0.5),
            CGPoint(x: 8.5, y: 0.5),
            CGPoint(x: 8.5, y: 1.5),
            CGPoint(x: 8.5, y: 2.5),
            CGPoint(x: 8.5, y: 3.5),
            CGPoint(x: 7.5, y: 3.5),
            CGPoint(x: 7.5, y: 2.5),
            CGPoint(x: 7.5, y: 1.5),
            CGPoint(x: 6.5, y: 1.5),
            CGPoint(x: 5.5, y: 1.5),
            CGPoint(x: 4.5, y: 1.5),
            CGPoint(x: 4.5, y: 0.5),
            CGPoint(x: 3.5, y: 0.5),
            CGPoint(x: 3.5, y: 1.5),
            CGPoint(x: 3.5, y: 2.5),
            CGPoint(x: 4.5, y: 2.5),
            CGPoint(x: 5.5, y: 2.5),
            CGPoint(x: 5.5, y: 3.5),
            CGPoint(x: 4.5, y: 3.5),
            CGPoint(x: 4.5, y: 4.5),
            CGPoint(x: 3.5, y: 4.5),
            CGPoint(x: 3.5, y: 3.5),
            CGPoint(x: 2.5, y: 3.5),
            CGPoint(x: 1.5, y: 3.5),
            CGPoint(x: 1.5, y: 2.5),
            CGPoint(x: 2.5, y: 2.5),
            CGPoint(x: 2.5, y: 1.5),
            CGPoint(x: 2.5, y: 0.5),
            CGPoint(x: 1.5, y: 0.5),
            CGPoint(x: 0.5, y: 0.5)])
    }
    
    // MARK: Generate tests
    func testGenerateEmptyMaze() {
        let mazeG = MazeGenerator(rows: 0, cols: 0)
        mazeG.generate()
        XCTAssertEqual(mazeG.maze.row, 1)
        XCTAssertEqual(mazeG.maze.col, 1)
    }

    func testGenerateSingleCellMaze() {
        let mazeG = MazeGenerator(rows: 1, cols: 1)
        mazeG.generate()
        XCTAssertEqual(mazeG.maze.row, 1)
        XCTAssertEqual(mazeG.maze.col, 1)
    }

    func testGenerateSoloRowMaze() {
        let mazeG = MazeGenerator(rows: 1, cols: 3)
        mazeG.generate()
        XCTAssertEqual(mazeG.maze.row, 1)
        XCTAssertEqual(mazeG.maze.col, 3)
        XCTAssertEqual(mazeG.maze.rightWalls[0], [false, false, true])
    }

    func testGenerateIdealMaze() {
        let mazeG = MazeGenerator(rows: 3, cols: 3)
        mazeG.generate()
        XCTAssertEqual(mazeG.maze.row, 3)
        XCTAssertEqual(mazeG.maze.col, 3)
        for i in 0..<mazeG.maze.row {
            for j in 0..<mazeG.maze.col {
                var isCheck = false
                
                if i < mazeG.maze.row.upward && mazeG.maze.lowerWalls[i][j] == false {
                    isCheck = true
                }
                if i > 0 && mazeG.maze.lowerWalls[i.upward][j] == false {
                    isCheck = true
                }
                if j < mazeG.maze.col.left && mazeG.maze.rightWalls[i][j] == false {
                    isCheck = true
                }
                if j > 0 && mazeG.maze.rightWalls[i][j.left] == false {
                    isCheck = true
                }

                XCTAssertTrue(isCheck)
            }
        }
    }
}
