//
//  MazeImage.swift
//  Maze
//
//  Created by Janiece Eleonour on 09.09.2024.
//

import SwiftUI

struct MazeImage: View {
    var maze: MazeData
    
    var body: some View {
        if let imageData = maze.imageData, let image = Image(data: imageData) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ZStack {
                Rectangle()
                    .fill(.tertiary)
                Image(systemName: "camera")
                    .font(.system(size: 64))
                    .foregroundStyle(.accent)
            }
        }
    }
}

#Preview {
    MazeImage(maze: .mazes.first!)
}
