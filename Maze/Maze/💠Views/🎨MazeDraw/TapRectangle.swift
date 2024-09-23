//
//  TapRectangle.swift
//  Maze
//
//  Created by Janiece Eleonour on 20.09.2024.
//
import SwiftUI

struct TapRectangle: View {
    @Binding var start: CGPoint?
    @Binding var end: CGPoint?
    @Binding var shortWay: [CGPoint]
    var maze: Maze
    var id: CGPoint
    
    private func reset() {
        start = nil
        end = nil
        shortWay = []
    }
    
    private func findPath() {
        if start == nil {
            start = id
        } else if end == nil {
            end = id
            shortWay = maze.findPath(from: start ?? .zero, to: end ?? .zero)
        } else {
            reset()
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(id == start || id == end ? Color.path : Color.clear)
            .contentShape(RoundedRectangle(cornerRadius: 4))
            .onTapGesture {
                withAnimation {
                    findPath()
                }
            }
            .onChange(of: maze) { _, _ in
                reset()
            }
#if os(iOS)
            .defersSystemGestures(on: .all)
#endif
    }
}

extension Maze: Equatable {
    public static func == (lhs: Maze, rhs: Maze) -> Bool {
        lhs.col.isMultiple(of: rhs.col) && lhs.row.isMultiple(of: rhs.row)
    }
}

