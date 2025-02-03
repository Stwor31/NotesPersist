//
//  NoteManager.swift
//  NotesPersist
//
//  Created by Steph on 3/2/2025.
//

import SwiftUI

@Observable

class NoteManager {
    var savedNotes: [Note] = []
    init(savedNotes: [Note]) {
        //        saveNote function goes here
    }
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getFilePath(for note: Note) -> URL {
        getDocumentDirectory().appendingPathComponent("\(note.id).json")
    }
    
    func saveNote(content : String) {
        let newNote = Note(id: UUID(), content: content, timestamp:Date())
        let filePath = getFilePath(for: newNote)
        
        do {
            let data = try JSONEncoder().encode(newNote)
            try data.write(to: filePath)
            savedNotes.append(newNote)
        } catch {
            print("Failed to save note : \(error.localizedDescription)")
        }
        
    }
    
    func loadSavedNotes() {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: getDocumentDirectory(), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            savedNotes = files.compactMap { file in
                guard let data = try? Data(contentsOf: file)
                else { return nil }
                return try? JSONDecoder().decode(Note.self, from: data)
            }.sorted{$0.timestamp > $1.timestamp}
        }
        catch {
            print("Failed to load notes : \(error.localizedDescription)")
        }
        
    }
    
    func deleteNote(at offsets: IndexSet) {
        for index in offsets {
            let note = savedNotes[index]
            let filepath = getFilePath(for: note)
            do {
                try FileManager.default.removeItem(at: filepath)
                savedNotes.remove(at: index)
            } catch {
                print("Failed to delete note : \(error.localizedDescription)")
            }
            
        }
    }
}

