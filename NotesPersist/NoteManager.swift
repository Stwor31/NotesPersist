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
/// need to be added to Keynote slides
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
    /// need to be added to Keynote slides
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
    /// need to be added to Keynote slides
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
    
    /// need to be review with UX. The share should show for the notes. Need to add details View to see notes and Fix ListView to show only the title of the notes.
    ///
    func exportNotesToPDF() {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            var yOffset: CGFloat = 20
            for note in savedNotes {
                let paragraph = "\(note.formattedDate)\n\(note.content)"
                let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]
                let attributedString = NSAttributedString(string: paragraph, attributes: attributes)
                attributedString.draw(in: CGRect(x: 20, y: yOffset, width: 572, height: 1000))
                yOffset += 60
            }
            
            
        }
        
        let filePath = getDocumentDirectory().appendingPathComponent("Notes.pdf")
        try? pdfData.write(to: filePath)
        
    }
}

/// could also consider having edit option for the notes
