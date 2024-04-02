//
//  File.swift
//
//
//  Created by Lukas Simonson on 3/19/24.
//

import Foundation

public struct Emoji: Codable, Equatable {
    public let character: String
    public let unicodeName: String
    public let group: String
    public let subGroup: String
    
    public init(for emoji: String) {
        self.character = emoji
        self.unicodeName = ""
        self.group = ""
        self.subGroup = ""
    }
    
    internal init(character: String, unicodeName: String, group: String, subGroup: String) {
        self.character = character
        self.unicodeName = unicodeName
        self.group = group
        self.subGroup = subGroup
    }
}

extension Emoji: TextSearchable {
    var searchableText: String {
        self.character + self.unicodeName + self.group + self.subGroup
    }
}
