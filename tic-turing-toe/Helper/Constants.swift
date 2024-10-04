//
//  Constants.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 9/22/24.
//
import UIKit

struct Constants {
    struct color {
        static let buttonBackgroundColor = UIColor(named: "button-color")
        static let labelTintColor = UIColor(named: "label-color")
        static let backgrroundColor = UIColor(named: "background-color")
        static let easyColor = UIColor(named: "easy-color")
        static let mediumColor = UIColor(named: "medium-color")
        static let hardColor = UIColor(named: "hard-color")
        static let friendColor = UIColor(named: "friend-color")
    }
    
    struct string {
        static let X = "X"
        static let O = "O"
        static let playerXTurn = "Player X's Turn"
        static let playerXWins = "Player X Wins!"
        static let itsADraw = "It's a Draw!"
        static let playerOTurn = "Player O's Turn"
        static let playerOWins = "Player O Wins!"
    }
}
