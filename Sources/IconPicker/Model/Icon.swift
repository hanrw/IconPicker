//
//  File.swift
//  
//
//  Created by Lukas Simonson on 3/19/24.
//

import Foundation
import SwiftUI

public enum Icon: Equatable {
    case symbol(name: String)
    case emoji(emoji: Emoji)

    static public let defaultIcon = Self.emoji(emoji: Emoji(character: "😀", unicodeName: "E1.0 grinning face", group: "smileys-emotion", subGroup: "face-smiling"))
}

extension Icon: Identifiable {
    public var id: String {
        switch self {
            case .emoji(let emoji): return emoji.unicodeName
            case .symbol(let name): return name
        }
    }
}

extension Icon: TextSearchable {
    var searchableText: String {
        switch self {
            case .symbol(let name):
                name
            case .emoji(let emoji):
                emoji.searchableText
        }
    }
}
