//
//  MazeDataGenerate.swift
//  Maze
//
//  Created by Janiece Eleonour on 11.09.2024.
//

import SwiftUI

struct MazeDataGenerate: View {
    let category: MazeCategory
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var mazeData: MazeData?
    @State private var mazeGenerate: MazeGenerate?
    @State private var rows: Int = 10
    @State private var columns: Int = 10
    @State private var isDisabled = true
    
    @State private var birthLimit: Int = 3
    @State private var deathLimit: Int = 6
    @State private var stepDelay: Double = 0.5
    @State private var isAutomatic: Bool = false
    @State private var timer: Timer?
    
    private var numbers: some View {
        ForEach(1...50, id: \.self) { amount in
            Text(amount, format: .number).tag(amount)
        }
    }
    
    private func generateMaze() {
        if category == .rectangularMaze {
            mazeGenerate = MazeGenerator(rows: rows, cols: columns)
            if let mazeGenerate {
                mazeGenerate.generate()
                mazeData = mazeGenerate.maze.toMazeData(name: name, category: category)
            }
        } else if category == .caveMaze {
            mazeGenerate = CaveGenerator(rows: rows, cols: columns)
            (mazeGenerate as? CaveGenerator)!.initCave()
            if let mazeGenerate {
                mazeData = mazeGenerate.maze.toMazeData(name: name, category: category)
            }
        }
        
        isDisabled = false
    }
    
    private func container<Content: View>(
        @ViewBuilder content: @escaping () -> Content) -> some View {
#if os(iOS)
        Form { content() }
#else
        Form { content()}
            .padding(50)
            .fixedSize()
#endif
    }
    
    var body: some View {
        container {
            Section("Name:") {
                TextField("", text: $name,
                          prompt: Text(Date.now, style: .time) + Text(" ") +
                                Text(Date.now, style: .date))
                    .foregroundStyle(isDisabled ? .gray : .accent)
                    .font(.headline)
                    .disabled(isDisabled)
            }
            
            Section("Generate Maze:") {
                Picker("Rows:", selection: $rows) {
                    numbers
                        .padding(.horizontal)
                }
                Picker("Columns:", selection: $columns) {
                    numbers
                        .padding(.horizontal)
                }
            }
            
            if category == .caveMaze {
                Section("Cave configuration:") {
                    Group {
                        Stepper("Birth limit: \(birthLimit)",
                                value: $birthLimit,
                                in: CaveConfigurations.minNeighbours...CaveConfigurations.maxNeighbours)
                        Stepper("Death limit: \(deathLimit)",
                                value: $deathLimit,
                                in: CaveConfigurations.minNeighbours...CaveConfigurations.maxNeighbours)
                        
                        Stepper("Delay: \(stepDelay, specifier: "%.1f") seconds",
                                value: $stepDelay, in: 0.3...5.0, step: 0.1)
                    }
                    .disabled(isAutomatic)
                }
            }
            
        }
#if os(macOS)
        .fixedSize(horizontal: true, vertical: true)
#endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                discardButton
            }
            ToolbarItem(placement: .primaryAction) {
                saveButton
            }
        }
        .onAppear {
            generateMaze()
        }
        .onChange(of: birthLimit) { _, _ in
            (mazeGenerate as? CaveGenerator)!.birthLimit = birthLimit
        }
        .onChange(of: deathLimit) { _, _ in
            (mazeGenerate as? CaveGenerator)!.deathLimit = deathLimit
        }
        .onChange(of: columns) { _, _ in
            generateMaze()
        }
        .onChange(of: rows) { _, _ in
            generateMaze()
        }
        Group {
            if let mazeData {
                MazeDraw(mazeData: mazeData)
                    .padding()
                    .frame(minWidth: 200,
                           idealWidth: 400,
                           maxWidth: .infinity,
                           minHeight: 200,
                           idealHeight: 400,
                           maxHeight: .infinity,
                           alignment: .center)
            }
            if category == .caveMaze {
                HStack {
                    playButton
                    stepButton
                    lastStepButton
                }
                .padding()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func nextStep() {
        if let caveGenerator = mazeGenerate as? CaveGenerator {
            caveGenerator.oneStep()
            mazeData = caveGenerator.maze.toMazeData(name: name, category: category)
        }
    }
    
    private func toggleAutomatic() {
        if isAutomatic {
            timer = Timer.scheduledTimer(withTimeInterval: stepDelay, repeats: true) { _ in
                nextStep()
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private var discardButton: some View {
        Button("Discard", systemImage: "xmark") {
            dismiss()
        }
    }
    
    private var lastStepButton: some View {
        Button {
            generateMaze()
        } label: {
            Image(systemName: "forward.end.alt.fill")
        }
#if os(iOS)
        .buttonStyle(MazeButtonStyle())
#endif
        .disabled(isAutomatic)
    }
    
    private var stepButton: some View {
        Button {
            nextStep()
        } label: {
            Image(systemName: "forward.end.fill")
        }
#if os(iOS)
        .buttonStyle(MazeButtonStyle())
#endif
        .disabled(isAutomatic)
    }
    
    private var playButton: some View {
        Button {
            isAutomatic.toggle()
            toggleAutomatic()
        } label: {
            Image(systemName: isAutomatic ? "pause.fill" : "play.fill")
        }
#if os(iOS)
        .buttonStyle(MazeButtonStyle())
#endif
    }
    
    private var saveButton: some View {
        Button("Save", systemImage: "doc.fill.badge.plus") {
            if let mazeData {
                mazeData.name = name
                modelContext.insert(mazeData)
            }
            dismiss()
        }
        .disabled(isDisabled)
    }
}

struct MazeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.accentReverse)
            .background(
                Color.accentColor
                    .clipShape(Capsule())
            )
    }
}

#Preview {
    NavigationStack {
        MazeDataGenerate(category: .caveMaze)
    }
}
