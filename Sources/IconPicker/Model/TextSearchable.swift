//
//  File.swift
//  
//
//  Created by Lukas Simonson on 3/20/24.
//

import Foundation

internal protocol TextSearchable {
    var searchableText: String { get }
}

extension Array where Element: TextSearchable {
    func searched(with text: String) -> [Element] {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return self }
        
        return self.filter { searchItem in
            searchItem.searchableText.range(of: text, options: .caseInsensitive) != nil
        }
    }
}
