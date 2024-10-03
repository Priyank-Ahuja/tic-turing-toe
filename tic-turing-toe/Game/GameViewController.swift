//
//  GameViewController.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/2/24.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: DefaultLabel!
    @IBOutlet weak var gameButton0: GameButton!
    @IBOutlet weak var gameButton1: GameButton!
    @IBOutlet weak var gameButton2: GameButton!
    @IBOutlet weak var gameButton3: GameButton!
    @IBOutlet weak var gameButton4: GameButton!
    @IBOutlet weak var gameButton5: GameButton!
    @IBOutlet weak var gameButton6: GameButton!
    @IBOutlet weak var gameButton7: GameButton!
    @IBOutlet weak var gameButton8: GameButton!
    
    @IBOutlet weak var gameBackgroundView: UIView!
    @IBOutlet weak var resetButton: DefaultButtonWithColor!
    
    var buttons: [GameButton]?
    var viewModel: GameViewModel?
    var board = [String](repeating: "", count: 9) // 9 empty slots
    var currentPlayer = "X"
    var gameActive = true
    
    let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6]             // Diagonals
    ]
    
    init(model: GameViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons = [gameButton0, gameButton1, gameButton2, gameButton3, gameButton4, gameButton5, gameButton6, gameButton7, gameButton8]
        
        switch viewModel?.level {
        case .easy:
            gameBackgroundView.backgroundColor = Constants.color.easyColor
        case .medium:
            gameBackgroundView.backgroundColor = Constants.color.mediumColor
        case .hard:
            gameBackgroundView.backgroundColor = Constants.color.hardColor
        case .friend:
            gameBackgroundView.backgroundColor = Constants.color.friendColor
        case .none:
            gameBackgroundView.backgroundColor = Constants.color.buttonBackgroundColor
        }
        
        statusLabel.text = "Player X's Turn"
    }
    
    func resetGame() {
        board = [String](repeating: "", count: 9)
        currentPlayer = "X"
        gameActive = true
        statusLabel.text = "Player X's Turn"
        
        guard let buttons else { return }
        
        for button in buttons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }
    
    // Check if the current player has won
    func checkForWinner() -> Bool {
        for combination in winningCombinations {
            if board[combination[0]] != "" && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return true
            }
        }
        return false
    }
    
    
    @IBAction func gameButttonsAction(_ sender: GameButton) {
        let tag = sender.tag
        
        // Ensure that the game is active and the cell is empty
        if gameActive && board[tag] == "" {
            board[tag] = currentPlayer
            sender.setTitle(currentPlayer, for: .normal)
            sender.isEnabled = false // Disable the button after marking it
            
            if checkForWinner() {
                statusLabel.text = "Player \(currentPlayer) Wins!"
                gameActive = false
            } else if board.contains("") == false {
                statusLabel.text = "It's a Draw!"
                gameActive = false
            } else {
                currentPlayer = (currentPlayer == "X") ? "O" : "X"
                statusLabel.text = "Player \(currentPlayer)'s Turn"
            }
        }
    }
    
    
    @IBAction func resetButtonAction(_ sender: Any) {
        resetGame()
    }
}
