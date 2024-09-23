//
//  MazeDetail.swift
//  Maze
//
//  Created by Janiece Eleonour on 09.09.2024.
//

import SwiftUI

struct MazeDetail: View {
    @Environment(\.displayScale) var displayScale
    var mazeData: MazeData
    
    @State private var isExporting = false
    @State private var exportText = ""
    @State private var textDocument: TextFile?
    @State private var error: ImportErrorSaver?
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            ViewThatFits(in: .horizontal) {
                wideDetails
                narrowDetails
            }
            .scenePadding()
        }
        .navigationTitle(mazeData.name)
        .toolbar {
            exportButton
            NavigationLink("Edit") {
                MazeEdit(maze: mazeData)
            }
        }
        .fileExporter(isPresented: $isExporting,
                      document: textDocument, 
                      contentType: .plainText) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let err):
                error = .parseError(err.localizedDescription)
            }
            
            exportText = ""
        }
    }
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: MazeDraw(mazeData: mazeData))

        // make sure and use the correct display scale for this device
        renderer.scale = displayScale
#if os(iOS)
        if let uiImage = renderer.uiImage {
            mazeData.imageData = uiImage.pngData()
        }
#else
        if let nsImage = renderer.nsImage {
            mazeData.imageData = nsImage.tiffRepresentation
        }
#endif
    }
    
    private var wideDetails: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    title.padding(.bottom)
                    Text("Rows: ") + Text(mazeData.toMaze.row, format: .number)
                    Text("Columns: ") + Text(mazeData.toMaze.col, format: .number)
                }
                .padding(.horizontal)
            }
            MazeDraw(mazeData: mazeData)
                .aspectRatio(contentMode: .fit)
                .padding()
        }
    }
    
    private var narrowDetails: some View {
        let alignment: HorizontalAlignment
#if os(macOS)
        alignment = .leading
#else
        alignment = .center
#endif
        return VStack(alignment: alignment, spacing: 22) {
            title
            MazeDraw(mazeData: mazeData)
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var title: some View {
#if os(macOS)
        Text(mazeData.name)
            .font(.largeTitle.bold())
#else
        EmptyView()
#endif
    }
    
    private var exportButton: some View {
        Button {
            exportText = mazeData.toMaze.parseMazeToText()
            print(exportText)
            textDocument = TextFile(initialText: exportText)
            isExporting = true
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
    }

}

#Preview {
    NavigationStack {
        MazeDetail(mazeData: .mazes.last!)
    }
}
