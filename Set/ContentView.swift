//
//  ContentView.swift
//  Set
//
//  Created by Lukas Hering on 13.12.22.
//

import SwiftUI

//design of the game
struct SetGameView: View {
    @ObservedObject var game: GameOfSet
    
    @Namespace var discardSpace
    @Namespace var deckSpace
    
    @State var initialCards = [GameOfSet.Card]()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Score: \(game.score)")
                    .bold().foregroundColor(.black).padding(.bottom)
                
                if !game.isEndOfGame {
                    AspectVGrid(items: game.playingCards, aspectRatio: 2/3) { card in
                        CardView(card: card, isUndealt: false)
                            .matchedGeometryEffect(id: card.id, in: discardSpace)
                            .matchedGeometryEffect(id: card.id * 100, in: deckSpace)
                            .padding(5)
                            .onTapGesture {
                                game.choose(card)
                                //extra Credit 2 (shuffle cards to discardpile before dealing 3 new cards)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        getPiledCards()
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        game.replaceASet()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    //extra Credit 4 (animating the Game Over Text)
                    withAnimation(.easeInOut(duration: 3)) {
                        Text("Game Over").foregroundColor(.green).font(.largeTitle)
                    }.rotationEffect(Angle.degrees(360))
                }
                
                HStack {
                    Spacer()
                    deckBody
                    Spacer()
                    restart
                    Spacer()
                    discardPileBody
                    Spacer()
                }
                .padding(.bottom)
            }
            .padding()
            .foregroundColor(.blue)
            .navigationBarHidden(true)
        }
    }
    
    private func isUndealt(_ card: GameOfSet.Card) -> Bool {
        return !game.playingCards.contains(card) && !card.isMatched
    }
    
    private func zIndex(of card: GameOfSet.Card) -> Double {
        -Double(game.allCards.firstIndex(of: card) ?? 0)
    }
    
    var deckBody: some View {
            ZStack {
                ForEach(game.allCards.filter(isUndealt)) { card in
                    CardView(card: card, isUndealt: true)
                        .matchedGeometryEffect(id: card.id * 100, in: deckSpace)
                        .zIndex(zIndex(of: card))
                }
            }
            .frame(width: 60, height: 90)
        .onTapGesture {
            withAnimation {
                getPiledCards()
            }
            withAnimation {
                game.dealThreeCards()
            }
        }
    }
    
   
    
    @State var matchedCards = [GameOfSet.Card]()
    
    private func getPiledCards() {
        for card in game.allCards.filter({ $0.isMatched }) {
            var dup = card
            dup.isMatched = false
            if !matchedCards.contains(dup) {
                matchedCards.append(dup)
            }
        }
    }
    
    //Pile of found matches
    var discardPileBody: some View {
        return ZStack {
            Color.clear
            ForEach(matchedCards) { card in
                CardView(card: card, isUndealt: false)
                    .matchedGeometryEffect(id: card.id, in: discardSpace)
            }
        }
        .frame(width: 60, height: 90)
    }
    
    //restart button design and logic
    var restart: some View {
        Button("Restart") {
            withAnimation {
                matchedCards = []
                game.newGame()
            }
        }
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = GameOfSet()
        SetGameView(game: game)
    }
}
