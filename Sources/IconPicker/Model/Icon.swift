//
//  File.swift
//  
//
//  Created by Lukas Simonson on 3/19/24.
//

import Foundation
import Smile

public enum Icon: Equatable {
    case symbol(name: String)
    case emoji(name: String, emoji: String)
    
    static var defaultIcon = Self.emoji(name: "grinning", emoji: "😀")
}

public extension Icon {
    static var allIcons: [Icon] { allEmojis + allSymbols }
}

public extension Icon {
    static let allEmojis: [Icon] = Smile.list().map { .emoji(name: name(emoji: $0).first ?? "", emoji: $0) }
}

public extension Icon {
    static let allSymbols: [Icon] = getSymbols()
    
    private static var symbolFile: String {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            "sfsymbol5"
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            "sfsymbol4"
        } else {
            "sfsymbol"
        }
    }

    private static func getSymbols() -> [Icon] {
        guard let path = Bundle.module.path(forResource: symbolFile, ofType: "txt"),
              let symbolList = try? String(contentsOfFile: path)
        else {
            #if DEBUG
            assertionFailure("IconPicker couldn't load SFSymbols")
            #endif

            return []
        }

        return symbolList
            .split(separator: "\n")
            .map { .symbol(name: String($0)) }
    }
}

extension Icon: Identifiable {
    public var id: String {
        switch self {
            case .emoji(let name, _): return name
            case .symbol(let name): return name
        }
    }
}
