import Foundation

struct Card {
    let yourNumbers: Set<Int>
    let winningNumbers: Set<Int>
    
    var matchCount: Int {
        yourNumbers.intersection(winningNumbers).count
    }
}


struct CardParser {
    static func parse(line: String) -> Card? {
        let parts = line.components(separatedBy: ": ")
        guard parts.count == 2 else { return nil }
        
        let sections = parts[1].components(separatedBy: " | ")
        guard sections.count == 2 else { return nil }
        
        let yourNumbers = parseNumbers(from: sections[0])
        let winningNumbers = parseNumbers(from: sections[1])
        
        return Card(yourNumbers: yourNumbers, winningNumbers: winningNumbers)
    }
    
    private static func parseNumbers(from string: String) -> Set<Int> {
        Set(string.components(separatedBy: " ")
            .compactMap { $0.isEmpty ? nil : Int($0) })
    }
}

class ScratchcardGame {
    private let cards: [Card]
    private var cardCounts: [Int: Int]
    
    init(cards: [Card]) {
        self.cards = cards
        self.cardCounts = Dictionary(uniqueKeysWithValues: 
            (1...cards.count).map { ($0, 1) }
        )
    }
    
    func calculateTotalCards() -> Int {
        processWinningCards()
        return cardCounts.values.reduce(0, +)
    }
    
    private func processWinningCards() {
        for cardIndex in 1...cards.count {
            let matchCount = cards[cardIndex - 1].matchCount
            if matchCount > 0 {
                updateFollowingCards(from: cardIndex, matchCount: matchCount)
            }
        }
    }
    
    private func updateFollowingCards(from currentIndex: Int, matchCount: Int) {
        let startIndex = currentIndex + 1
        let endIndex = min(currentIndex + matchCount, cards.count)
        let currentCardCount = cardCounts[currentIndex] ?? 0
        
        for index in startIndex...endIndex {
            cardCounts[index] = (cardCounts[index] ?? 0) + currentCardCount
        }
    }
}


do {
    let filePath = "input.txt"
    let contents = try String(contentsOfFile: filePath, encoding: .utf8)
    
    let cards = contents.components(separatedBy: .newlines)
        .compactMap(CardParser.parse)
    
    let game = ScratchcardGame(cards: cards)
    let total = game.calculateTotalCards()
    
    print("Total cards: \(total)")
} catch {
    print("Error reading file: \(error)")
}