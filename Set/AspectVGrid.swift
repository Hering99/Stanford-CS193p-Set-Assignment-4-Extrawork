//
//  AspectVGrid.swift
//  Set
//
//  Created by Lukas Hering on 14.12.22.
//

import SwiftUI

//having the cards be resizeable and ordered
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    let items: [Item]
    let aspectRatio: CGFloat
    let content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

//putting the symbol onto the card and make it fit
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    let width: CGFloat = max(widthThatBestFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio), 80)
                    LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                        ForEach(items) {
                            content($0)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
//making the cardgrid resizeable and fitting
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatBestFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = Int(ceil(Double(itemCount) / Double(columnCount)))
            
        } while columnCount < itemCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}

//struct AspectVGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        AspectVGrid()
//    }
//}
