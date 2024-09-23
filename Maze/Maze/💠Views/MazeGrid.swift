//
//  MazeGrid.swift
//  Maze
//
//  Created by Janiece Eleonour on 09.09.2024.
//

import SwiftData
import SwiftUI

struct MazeGrid: View {
    let mazeDataModel: MazeDataModel
    /// The category of mazes to display.
    let category: MazeCategory?

    /// A `Binding` to the identifier of the selected maze.
    @Binding var selection: MazeData.ID?

    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(MazeNavigationModel.self) private var navigationModel
    
    @State private var isPresentedGenerateSheet: Bool = false

    /// The currently-selected maze.
    private var selectedMaze: MazeData? {
        mazeDataModel[selection]
    }
    
    /// The recipes of the category.
    private var mazes: [MazeData] {
        mazeDataModel.mazes(in: category)
    }

    private func gridItem(for maze: MazeData) -> some View {
        MazeTile(maze: maze, isSelected: selection == maze.id)
            .id(maze.id)
            .padding(Self.spacing)
            .onTapGesture {
                navigationModel.selectedMazeID = maze.id
            }
    }

    var body: some View {
        if let category = category {
            container { _, scrollViewProxy in
                LazyVGrid(columns: columns, alignment: .leading) {
                    ForEach(mazes) { maze in
                        gridItem(for: maze)
                    }
                }
                .padding(Self.spacing)
                .focusable()
                .focusEffectDisabled()
                .focusedValue(\.selectedMaze, selectedMaze)
                .onKeyPress(.return, action: {
                    if let maze = selectedMaze {
                        navigate(to: maze)
                        return .handled
                    } else {
                        return .ignored
                    }
                })
                .onKeyPress(.escape) {
                    selection = nil
                    return .handled
                }
                .onKeyPress(characters: .alphanumerics, phases: .down) { keyPress in
                    selectMaze(
                        matching: keyPress.characters,
                        scrollViewProxy: scrollViewProxy)
                }
            }
            .toolbar {
                Button {
                    isPresentedGenerateSheet = true
                } label: {
                    Label("Generate Maze", systemImage: "wand.and.stars")
                }
            }
            .navigationTitle(category.name)
            .navigationDestination(for: MazeData.ID.self) { mazeID in
                if let mazeData = mazes[mazeID] {
                    MazeDetail(mazeData: mazeData)
                }
            }
            .sheet(isPresented: $isPresentedGenerateSheet) {
                NavigationStack {
                    MazeDataGenerate(category: category)
                }
            }
        } else {
            ContentUnavailableView("Choose a category",
                                   systemImage: "square.grid.3x3.topleft.filled")
                .navigationTitle("")
        }
    }

    private func container<Content: View>(
        @ViewBuilder content: @escaping (
            _ geometryProxy: GeometryProxy, _ scrollViewProxy: ScrollViewProxy) -> Content
    ) -> some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    content(geometryProxy, scrollViewProxy)
                }
            }
        }
    }

    // MARK: Keyboard selection

    private func navigate(to maze: MazeData) {
        navigationModel.selectedMazeID = maze.id
    }

    private func selectMaze(
        matching characters: String,
        scrollViewProxy: ScrollViewProxy
    ) -> KeyPress.Result {
        if let matchedMaze = mazes.first(where: { maze in
            maze.name.lowercased().starts(with: characters)
        }) {
            selection = matchedMaze.id
            scrollViewProxy.scrollTo(selection)
            return .handled
        }
        return .ignored
    }

    // MARK: Grid layout

    private static let spacing: CGFloat = 10

    private var columns: [GridItem] {
        [ GridItem(.fixed(MazeTile.size), spacing: 0) ]
    }
}
