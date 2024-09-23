//
//  MazeExporter.swift
//  Maze
//
//  Created by Janiece Eleonour on 14.09.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]
    
    // by default our document is empty
    var text = ""
    
    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let text = String(data: data, encoding: .utf8) else {
            throw ParseError.invalidFormat("")
        }
        self.text = text
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

extension Maze {
    public func parseMazeToText() -> String {
        let rows = lowerWalls.count
        let columns = lowerWalls[0].count
        
        var result = "\(rows) \(columns)\n"
        
        for i in 0..<rows {
            for j in 0..<columns {
                result += rightWalls[i][j] ? "1 " : "0 "
            }
            result += "\n"
        }
        
        result += "\n"
        
        for i in 0..<rows {
            for j in 0..<columns {
                result += lowerWalls[i][j] ? "1 " : "0 "
            }
            result += "\n"
        }
        
        return result
    }
    
}
