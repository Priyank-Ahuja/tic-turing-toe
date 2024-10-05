//
//  SavedGameCellModel.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/4/24.
//
import Foundation

class SavedGameCellModel {
    var game: Game?
    var dateString: String?
    var sno = ""

    
    init(game: Game, sno:String) {
        self.game = game
        guard let date = game.date else {return}
        let formatter3 = DateFormatter()
        formatter3.dateFormat =  "MM/dd/yy"
        formatter3.string(from: date)
        self.dateString = formatter3.string(from: date)
        self.sno = sno
    }
}
