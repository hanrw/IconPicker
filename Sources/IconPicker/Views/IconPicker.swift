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
            case .symbol(let name):
                Image(systemName: name)
            case .emoji(let emoji):
                Text(emoji.character)
        }
    }
}

public struct IconPicker<S: Shape>: View {
    
    @ScaledMetric(relativeTo: .largeTitle) private var size = 65
    
    @Binding private var selection: Icon
    @State private var listSelection: ListOption = .emojis
    @State private var searchText: String = ""
    
    @StateObject private var iconPackage = IconPackage.shared
    
    private let backgroundShape: S
    private let backgroundColorDefault: Color
    private let backgroundColorSelected: Color
    private let iconColorDefault: Color
    private let iconColorSelected: Color
    
    public init(
        selection: Binding<Icon>,
        backgroundShape: S,
        itemBackgroundColor: Color = Color(uiColor: UIColor.secondarySystemBackground),
        itemBackgroundColorSelected: Color = .accentColor,
        iconColorDefault: Color = .primary,
        iconColorSelected: Color = .primary
    ) {
        self._selection = selection
        self.backgroundShape = backgroundShape
        self.backgroundColorDefault = itemBackgroundColor
        self.backgroundColorSelected = itemBackgroundColorSelected
        self.iconColorDefault = iconColorDefault
        self.iconColorSelected = iconColorSelected
    }
    
    private var icons: [Icon] {
        switch listSelection {
            case .symbols:
                return iconPackage.searchSymbols(searchText)
            case .emojis:
                return iconPackage.searchEmojis(searchText)
        }
    }
    
    public var body: some View {
        ScrollView {
            Picker("", selection: $listSelection) {
                Text("Emojis").tag(ListOption.emojis)
                Text("Symbols").tag(ListOption.symbols)
            }
            .pickerStyle(.segmented)
            
            if !icons.isEmpty {
                LazyVGrid(columns: [.init(.adaptive(minimum: size + 10))]) {
                    ForEach(icons) { icon in
                        backgroundShape
                            .fill(selection == icon ? backgroundColorSelected : backgroundColorDefault)
                            .frame(width: size + 10, height: size + 10)
                            .overlay {
                                IconView(for: icon)
                                    .font(.largeTitle)
                                    .foregroundStyle(selection == icon ? iconColorSelected : iconColorDefault)
                            }
                            .onTapGesture {
                                withAnimation {
                                    selection = icon
                                }
                            }
                    }
                }
            } else {
                switch listSelection {
                    case .symbols: Text("No Symbols Match Search")
                    case .emojis: Text("No Emojis Match Search")
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
        itemBackgroundColorSelected: Color = .accentColor,
        iconColorDefault: Color = .primary,
        iconColorSelected: Color = .primary
    ) {
        self._selection = selection
        self.backgroundShape = RoundedRectangle(cornerRadius: 15)
        self.backgroundColorDefault = itemBackgroundColor
        self.backgroundColorSelected = itemBackgroundColorSelected
        self.iconColorDefault = iconColorDefault
        self.iconColorSelected = iconColorSelected
    }
}

#Preview {
    IconPreview()
}
