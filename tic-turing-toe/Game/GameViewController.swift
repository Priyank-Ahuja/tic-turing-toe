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
        
        setupInterface()
        
        statusLabel.text = Constants.string.playerXTurn
    }
    
    func setupInterface() {
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
    }
    
    func updateUI(forPlayer player: String, atIndex index: Int) {
        buttons?[index].setTitle(player, for: .normal)
        buttons?[index].isEnabled = false
    }
    
    
    @IBAction func gameButttonsAction(_ sender: GameButton) {
        let tag = sender.tag
        
        if viewModel?.processMove(at: tag, forPlayer: Constants.string.X) == true {
            updateUI(forPlayer: Constants.string.X, atIndex: tag)
            
            if viewModel?.checkForWinner() == true {
                statusLabel.text = Constants.string.playerXWins
            } else if viewModel?.board.contains("") == false {
                statusLabel.text = Constants.string.itsADraw
            } else {
                statusLabel.text = Constants.string.playerOTurn
                let aiMoveIndex = viewModel?.aiMove() ?? -1
                updateUI(forPlayer: Constants.string.O, atIndex: aiMoveIndex)
                
                if viewModel?.checkForWinner() == true {
                    statusLabel.text = Constants.string.playerOWins
                } else if viewModel?.board.contains("") == false {
                    statusLabel.text = Constants.string.itsADraw
                } else {
                    statusLabel.text = Constants.string.playerXTurn
                }
            }
        }
    }
    
    @IBAction func changeLevelAction(_ sender: Any) {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        self.navigationController?.present(settingsViewController, animated: true)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        viewModel?.resetGame()
        statusLabel.text = Constants.string.playerXTurn
        buttons?.forEach { button in
            button.setTitle("", for: .normal)
            button.isEnabled = true
        }
    }
}

extension GameViewController: SettingsViewControllerDelegate {
    func didSelectLevel(level: GameLevel) {
        self.viewModel?.level = level
        setupInterface()
    }
}
