//
//  📝MazeEdit.swift
//  Maze
//
//  Created by Janiece Eleonour on 11.09.2024.
//

import SwiftUI
import PhotosUI
import SwiftData

struct MazeEdit: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var maze: MazeData
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var text = ""
    @State private var error: ImportErrorSaver?
    @State private var isImporting = false
    @State private var showAlert = false
    @State private var rightWallsRow = 0
    @State private var lowerWallsRow = 0
    
    private var amountRows: some View {
        ForEach(0..<maze.toMaze.row, id: \.self) { amount in
            Text(amount, format: .number)
        }
    }
    
    private var importButton: some View {
        Button {
            isImporting = true
        } label: {
            Label("Import file", systemImage: "square.and.arrow.down")
        }
    }
    
    private var imagePicker: some View {
        // Change photo button
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
#if os(macOS)
            Text("Change image")
#else
            // Display the current image
            MazeImage(maze: maze)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal)
#endif
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                // Retrieve selected asset in the form of Data
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    maze.imageData = data
                }
            }
        }
    }
    
    private func changeWalls(walls: Binding<[Bool]>) -> some View {
        ScrollView(.horizontal) {
                HStack {
                    ForEach(walls.indices, id: \.self) { j in
                        Toggle(isOn: Binding<Bool>(
                            get: { walls[j].wrappedValue },
                            set: { walls[j].wrappedValue = $0 }
                        )) {
                            Text(j, format: .number)
                                .font(.caption2)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private func container<Content: View>( @ViewBuilder content: @escaping () -> Content) -> some View {
#if os(iOS)
        Form { content() }
#else
        List { content() }
#endif
    }
    
    var body: some View {
        container {
            Section("Name:") {
                TextField(text: $maze.name) { }
                    .font(.headline)
            }
            Section("Image:") {
                imagePicker
            }
            // Display and edit right walls
            Section("Right Walls") {
                Picker("Rows:", selection: $rightWallsRow) {
                    amountRows
                        .padding(.horizontal)
                }
                changeWalls(walls: $maze.rightWalls[rightWallsRow])
            }
            // Display and edit lower walls
            Section("Lower Walls") {
                Picker("Rows:", selection: $lowerWallsRow) {
                    amountRows
                        .padding(.horizontal)
                }
                changeWalls(walls: $maze.lowerWalls[lowerWallsRow])
            }
        }
        .toolbar {
            importButton
        }
        .alert(isPresented: $showAlert, error: error) { _ in
            Button("OK") {
                showAlert = false
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later.")
        }
        .onDisappear {
            try? modelContext.save()
        }
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: [.text]) {
            let result = $0.flatMap { url in
                read(from: url)
            }
            switch result {
            case .success(let strings):
                text += strings
                importFromText()
            case .failure(let failure):
                error = .invalidData(failure.localizedDescription)
                showAlert = true
            }
        }
    }
    
    private func importFromText() {
        let parseResult = ParseMazeFiles(str: text).parse()
        
        switch parseResult {
        case .success(let success):
            maze.rightWalls = success.rightWalls
            maze.lowerWalls = success.lowerWalls
        case .failure(let failure):
            error = .parseError(failure.localizedDescription)
            showAlert = true
        }
        
    }
    
    private func read(from url: URL) -> Result<String, Error> {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        return Result { try String(contentsOf: url, encoding: .utf8) }
    }
    
}

#Preview {
    MazeEdit(maze: .mazes.first!)
}
