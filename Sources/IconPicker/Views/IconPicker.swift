//
//  SwiftUIView.swift
//
//
//  Created by Lukas Simonson on 3/19/24.
//

import SwiftUI

public struct IconView: View {
    private let icon: Icon
    
    public init(for icon: Icon) {
        self.icon = icon
    }
    
    public var body: some View {
        switch self.icon {
            case .symbol(let symbolName):
                Image(systemName: symbolName)
            case .emoji(_, let emoji):
                Text(emoji)
        }
    }
}

public struct IconPicker<S: Shape>: View {
    
    @ScaledMetric(relativeTo: .largeTitle) private var size = 65
    
    @Binding private var selection: Icon
    @State private var listSelection: ListOption = .emojis
    @State private var searchText: String = ""
    
    private let backgroundShape: S
    private let backgroundColorDefault: Color
    private let backgroundColorSelected: Color
    
    public init(
        selection: Binding<Icon>,
        backgroundShape: S,
        itemBackgroundColor: Color = Color(uiColor: UIColor.secondarySystemBackground),
        itemBackgroundColorSelected: Color = .accentColor
    ) {
        self._selection = selection
        self.backgroundShape = backgroundShape
        self.backgroundColorDefault = itemBackgroundColor
        self.backgroundColorSelected = itemBackgroundColorSelected
    }
    
    private var icons: [Icon] {
        switch listSelection {
            case .symbols:
                return Icon.allSymbols.searched(searchText)
            case .emojis:
                return Icon.allEmojis.searched(searchText)
        }
    }
    
    public var body: some View {
        ScrollView {
            Picker("", selection: $listSelection) {
                Text("Emojis").tag(ListOption.emojis)
                Text("Symbols").tag(ListOption.symbols)
            }
            .pickerStyle(.segmented)
            
            
            LazyVGrid(columns: [.init(.adaptive(minimum: size + 10))]) {
                ForEach(icons) { icon in
                    backgroundShape
                        .fill(selection == icon ? backgroundColorSelected : backgroundColorDefault)
                        .frame(width: size + 10, height: size + 10)
                        .overlay {
                            IconView(for: icon)
                                .font(.largeTitle)
                        }
                        .onTapGesture {
                            print(icon)
                            withAnimation { selection = icon }
                        }
                }
            }
        }
        .searchable(text: $searchText)
        .padding(.horizontal)
    }
    
    private enum ListOption {
        case symbols
        case emojis
    }
}

private extension Array where Element == Icon {
    func searched(_ searchText: String) -> [Icon] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return self
        }
        
        return self.filter { icon in
            icon.id.range(of: searchText, options: .caseInsensitive) != nil
        }
    }
}

struct IconPreview: View {
    @State private var selection: Icon = .defaultIcon
    
    var body: some View {
        NavigationStack {
            IconPicker(selection: $selection)
        }
        .tint(Color.green)
    }
}

public extension IconPicker where S == RoundedRectangle {
    init(
        selection: Binding<Icon>,
        itemBackgroundColor: Color = Color(uiColor: UIColor.secondarySystemBackground),
        itemBackgroundColorSelected: Color = .accentColor
    ) {
        self._selection = selection
        self.backgroundShape = RoundedRectangle(cornerRadius: 15)
        self.backgroundColorDefault = itemBackgroundColor
        self.backgroundColorSelected = itemBackgroundColorSelected
    }
}

#Preview {
    //    IconPicker(selection: .constant(nil))
    IconPreview()
}
