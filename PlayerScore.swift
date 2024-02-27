import Foundation
import SwiftData

@Model
class PlayerScore: Identifiable {
    var id = UUID()
    var playerName: String
    var humanScore: Int
    var alienScore: Int
    
    init(playerName: String, humanScore: Int, alienScore: Int) {
        self.playerName = playerName
        self.humanScore = humanScore
        self.alienScore = alienScore
    }
}
