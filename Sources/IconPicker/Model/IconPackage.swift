//
//  File.swift
//  
//
//  Created by Lukas Simonson on 3/20/24.
//

import Foundation

class IconPackage: ObservableObject {
    @Published fileprivate(set) var allSymbols: [Icon]
    @Published fileprivate(set) var allEmojis: [Icon]
    var allIcons: [Icon] { allSymbols + allEmojis }
    
    private init(allSymbols: [Icon], allEmojis: [Icon]) {
        self.allSymbols = allSymbols
        self.allEmojis = allEmojis
    }
    
    func searchEmojis(_ searchText: String) -> [Icon] {
        self.allEmojis.searched(with: searchText)
    }
    
    func searchSymbols(_ searchText: String) -> [Icon] {
        self.allSymbols.searched(with: searchText)
    }
}

extension IconPackage {
    
    static let shared = IconPackage()
    
    public convenience init() {
        self.init(allSymbols: [], allEmojis: [])
        Task {
            async let allSymbols = Self.getSymbols()
            async let allEmojis = Self.getEmojis()
            
            let icons = await (allSymbols, allEmojis)
            
            await MainActor.run {
                self.allSymbols = icons.0
                self.allEmojis = icons.1
            }
        }
    }
    
    private static func getSymbolFileName() -> String {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            "sfsymbol5"
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            "sfsymbol4"
        } else {
            "sfsymbol"
        }
    }

    private static func getSymbols() async -> [Icon] {
        guard let path = Bundle.module.path(forResource: getSymbolFileName(), ofType: "txt"),
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
    
    private static func getEmojis() async -> [Icon] {
        guard let bundle = Bundle(identifier: Bundle.module.bundleIdentifier!),
              let url = bundle.url(forResource: "emojis", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let emojis = try? JSONDecoder().decode([Emoji].self, from: data)
        else {
            #if DEBUG
            assertionFailure("Failed To Load Emojis")
            #endif
            return []
        }
        
        return emojis.map { .emoji(emoji: $0) }
    }
}
