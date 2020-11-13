//
//  Grid.swift
//  Memorize
//
//  Created by De La Cruz, Eduardo on 05/11/2020.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: GridLayout(itemCount: items.count, nearAspectRatio: (2/3), in: geometry.size))
//            body(for: GridLayout(itemCount: items.count, in: geometry.size))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        return ForEach(items) {
            item in self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        return Group {
            if let index = items.firstIndex(matching: item) {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}
