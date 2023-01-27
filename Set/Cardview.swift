//
//  Cardview.swift
//  Set
//
//  Created by Lukas Hering on 14.12.22.
//


import SwiftUI

//design of a single card
struct CardView: View {
    let card: GameOfSet.Card
    var isUndealt : Bool
    
    
    var body: some View {
        
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cardCornerRadius)
            cardShape.fill().foregroundColor(.white)
            cardShape.strokeBorder(lineWidth: DrawingConstants.defaultLineWidth)
            symbol
            
            cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.orange).opacity(card.isChosen ? 1 : 0)
            
            cardShape.foregroundColor(.yellow).opacity( card.isHint ? DrawingConstants.effectOpacity : 0)
            cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.yellow).opacity(card.isHint ? 1 : 0)
            
            cardShape.foregroundColor(.green).opacity(card.isMatched ? DrawingConstants.effectOpacity : 0).animation(.easeInOut(duration: 1))
            cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.green).opacity(card.isMatched ? 1 : 0)
            
            cardShape.strokeBorder(lineWidth: DrawingConstants.effectLineWidth).foregroundColor(.gray).opacity(card.isNotMatched ? 1 : 0)
            
            cardShape
                .opacity(isUndealt ? 1 : 0)
        }
        // change with customed shake viewModifier later on
        
        .rotationEffect(Angle.degrees(card.isNotMatched ? 3 : 0))
        .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
        .animation(.easeInOut(duration: card.isMatched ? 1 : 0.1))
        
        
    }
    
    var symbol: some View {
        VStack {
            ForEach(0..<card.symbol.numberOfShapes, id: \.self) { _ in
                createSymbol(for: card)
            }
        }
        .padding()
    }
    
    
    @ViewBuilder
    func createSymbol(for card: GameOfSet.Card) -> some View {
        switch card.symbol.shape {
        case .roundedRectangle:
            createSymbolView(of: card.symbol, shape: RoundedRectangle(cornerRadius: DrawingConstants.symbolCornerRadius))
        case .rectangleWithCorners:
            createSymbolView(of: card.symbol, shape: Rectangle())
        case .diamond:
            createSymbolView(of: card.symbol, shape: Diamond())
        }
    }
    

    @ViewBuilder
    private func createSymbolView<SymbolShape>(of symbol: GameOfSet.Card.CardContent, shape: SymbolShape) -> some View where SymbolShape: Shape {
        
        switch symbol.pattern {
        case .filled:
            shape.fill().foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
            
        case .shaded:
            shape.fill().foregroundColor(symbol.color.getColor())
                           .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(0.3)
            
        case .stroked:
            shape.stroke(lineWidth: DrawingConstants.defaultLineWidth).foregroundColor(symbol.color.getColor())
                .aspectRatio(DrawingConstants.symbolAspectRatio, contentMode: .fit).opacity(DrawingConstants.symbolOpacity)
        }
    }
    
    struct DrawingConstants {
        static let symbolAspectRatio: CGFloat = 2/1
        static let symbolOpacity: Double = 0.7
        static let symbolCornerRadius: CGFloat = 50
        
        static let defaultLineWidth: CGFloat = 2
        static let effectLineWidth: CGFloat = 3
        static let cardCornerRadius: CGFloat = 10
        static let effectOpacity: Double = 1
        
    }
}

