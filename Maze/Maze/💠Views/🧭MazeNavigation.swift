//
//  🧭MazeNavigation.swift
//  Maze
//
//  Created by Janiece Eleonour on 05.09.2024.
//

import SwiftData
import SwiftUI

struct MazeNavigation: View {
    @Environment(\.modelContext) var modelContext
    /// The mazes of the category.
    @Query(sort: [SortDescriptor(\MazeData.name, order: .forward)]) var mazes: [MazeData]
    @Bindable var mazeNavigationModel: MazeNavigationModel
    
    @State var selectedMaze: MazeData.ID?
    var categories = MazeCategory.allCases
    
    var body: some View {
        NavigationSplitView {
            List(categories, selection: $mazeNavigationModel.selectedCategory) { category in
                NavigationLink(category.name, value: category)
            }
            .navigationTitle("Categories")
        } detail: {
            NavigationStack(path: $mazeNavigationModel.mazePath) {
                MazeGrid(mazeDataModel: MazeDataModel(mazes: mazes),
                         category: mazeNavigationModel.selectedCategory, 
                         selection: $selectedMaze)
            }
        }
    }
}

