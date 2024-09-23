//
//  Line.swift
//  Maze
//
//  Created by Janiece Eleonour on 20.09.2024.
//

import SwiftUI

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}
