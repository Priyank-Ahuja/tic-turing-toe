//
//  HomeViewController.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 9/22/24.
//

import UIKit

final class HomeViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newGameButtonAction(_ sender: Any) {
        let settingsViewController = SettingsViewController()
        settingsViewController.delegate = self
        self.navigationController?.present(settingsViewController, animated: true)
    }
}

extension HomeViewController: SettingsViewControllerDelegate {
    func didSelectLevel(level: GameLevel) {
        let model = GameViewModel(level: level)
        let gameViewController = GameViewController(model: model)
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}
