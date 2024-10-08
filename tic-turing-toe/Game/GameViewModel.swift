//
//  GameViewModel.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/3/24.
//

class GameViewModel {
    var board = [String](repeating: "", count: 9) // 9 empty slots
    var currentPlayer = Constants.string.X
    var gameActive = true
    var level: GameLevel?
    
    let winningCombinations = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6]             // Diagonals
    ]
    
    init(level: GameLevel?) {
        self.level = level
    }
    
    // Reset the game
    func resetGame() {
        board = [String](repeating: "", count: 9)
        currentPlayer = Constants.string.X
        gameActive = true
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
    
    // Process player move
    func processMove(at index: Int, forPlayer player: String) -> Bool {
        if gameActive && board[index] == "" {
            board[index] = player
            return true
        }
        return false
    }
    
    // AI makes its move
    func aiMove() -> Int {
        guard gameActive else { return -1 }
        
        let move: Int
        switch level {
        case .easy:
            move = randomMove()
        case .medium:
            move = Bool.random() ? randomMove() : optimalMove()
        case .hard:
            move = optimalMove()
        case .friend:
            move = randomMove()
        case .none:
            move = randomMove()
        }
        
        board[move] = Constants.string.O
        return move
    }
    
    // Random move for AI
    func randomMove() -> Int {
        var emptySlots = [Int]()
        for (index, value) in board.enumerated() {
            if value == "" {
                emptySlots.append(index)
            }
        }
        return emptySlots.randomElement() ?? 0
    }
    
    // Optimal move using Minimax algorithm
    func optimalMove() -> Int {
        return minimax(board: board, depth: 0, isMaximizing: true, alpha: Int.min, beta: Int.max).position
    }
    
    // Minimax algorithm with alpha-beta pruning
    func minimax(board: [String], depth: Int, isMaximizing: Bool, alpha: Int, beta: Int) -> (score: Int, position: Int) {
        if let winner = evaluate(board: board) {
            return (winner, -1)
        }
        
        if !board.contains("") {
            return (0, -1) // Draw
        }
        
        var alpha = alpha
        var beta = beta
        var bestPosition = -1
        
        if isMaximizing {
            var bestScore = Int.min
            for i in 0..<board.count where board[i] == "" {
                var newBoard = board
                newBoard[i] = Constants.string.O
                let result = minimax(board: newBoard, depth: depth + 1, isMaximizing: false, alpha: alpha, beta: beta)
                if result.score > bestScore {
                    bestScore = result.score
                    bestPosition = i
                }
                alpha = max(alpha, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestPosition)
        } else {
            var bestScore = Int.max
            for i in 0..<board.count where board[i] == "" {
                var newBoard = board
                newBoard[i] = Constants.string.X
                let result = minimax(board: newBoard, depth: depth + 1, isMaximizing: true, alpha: alpha, beta: beta)
                if result.score < bestScore {
                    bestScore = result.score
                    bestPosition = i
                }
                beta = min(beta, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestPosition)
        }
    }
    
    // Evaluate the board state
    func evaluate(board: [String]) -> Int? {
        for combination in winningCombinations {
            if board[combination[0]] == Constants.string.O && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return 1 // AI wins
            } else if board[combination[0]] == Constants.string.X && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]] {
                return -1 // Human wins
            }
        }
        return nil
    }
}
