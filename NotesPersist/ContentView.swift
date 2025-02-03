//
//  ContentView.swift
//  NotesPersist
//
//  Created by Steph on 3/2/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var newNoteContent = ""
    var noteManager = NoteManager(savedNotes: [])
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text ("What did you learn today ? ")
                    .font(.title)
                    .multilineTextAlignment(.center)
                TextEditor(text: $newNoteContent)
                    .frame(height: 300)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                Button("Save note") {
                    noteManager.saveNote(content: newNoteContent)
                    newNoteContent = ""
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                List {
                    ForEach (noteManager.savedNotes) { note in
                        VStack {
                            Text (note.content)
                                .font(.headline)
                            Text (note.formattedDate)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                    .onDelete(perform: noteManager.deleteNote)
                }
                .navigationTitle("Notes")
                
            }
            .padding()
        }
    }
    
}

#Preview {
    ContentView()
}
