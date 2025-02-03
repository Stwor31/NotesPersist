//
//  Model.swift
//  NotesPersist
//
//  Created by Steph on 3/2/2025.
//

import Foundation

struct Note : Identifiable, Codable {
    let id: UUID
    let content: String
    let timestamp: Date
    
    var formattedDate: String {
        timestamp.formatted(date: .abbreviated, time: .shortened)
    }
}

///It conforms to Identifiable which is great for SwiftUI integration
///It conforms to Codable which allows for JSON encoding/decoding
///The content and timestamp are let constants, making the note immutable after creation
///The computed property formattedDate provides a nicely formatted string representation of the timestamp
///The UUID is automatically generated with a default value, which is convenient
