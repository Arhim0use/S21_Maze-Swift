//
//  MazeTile.swift
//  Maze
//
//  Created by Janiece Eleonour on 09.09.2024.
//

import SwiftUI

struct MazeTile: View {
    var maze: MazeData
    var isSelected: Bool
    
    private var strokeStyle: AnyShapeStyle {
        isSelected
        ? AnyShapeStyle(.selection)
        : AnyShapeStyle(.clear)
    }
    
    var body: some View {
        HStack {
            imageView
            captionView
        }
    }
}

extension MazeTile {
    static let size: CGFloat = 340
    static let selectionStrokeWidth: CGFloat = 4
}

extension MazeTile {
    private var imageView: some View {
        MazeImage(maze: maze)
            .frame(width: 150)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(.containerRelative)
            .padding(Self.selectionStrokeWidth)
            .overlay(
                ContainerRelativeShape()
                    .inset(by: -Self.selectionStrokeWidth / 1.5)
                    .strokeBorder(
                        strokeStyle,
                        lineWidth: Self.selectionStrokeWidth)
            )
            .shadow(color: .black.opacity(0.05), radius: 0.5, x: 0, y: -1)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            .containerShape(.rect(cornerRadius: 20))
    }
    
    private var captionView: some View {
        VStack(alignment: .leading) {
            Text(maze.name)
                .lineLimit(2)
                .truncationMode(.tail)
                .font(.headline)
                .padding(.bottom)
            Group {
                Text("Rows: ") +
                Text(maze.toMaze.row, format: .number)
                Text("Columns: ") +
                Text(maze.toMaze.col, format: .number)
            }
            .truncationMode(.tail)
            .font(.caption)
        }
    }
}

#Preview {
    MazeTile(maze: MazeData.mazes.first!, isSelected: true)
}
