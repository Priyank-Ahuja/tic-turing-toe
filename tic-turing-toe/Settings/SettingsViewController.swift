//
//  SettingsViewController.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 9/22/24.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func didSelectLevel(level: GameLevel)
}

final class SettingsViewController: UIViewController {
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        setupPresentationController()
    }
    
    private func setupPresentationController() {
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
    }
    
    @IBAction func easyButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectLevel(level: .easy)
        }
    }
    
    @IBAction func mediumButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectLevel(level: .medium)
        }
    }
    
    @IBAction func hardButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectLevel(level: .hard)
        }
    }
    
    @IBAction func friendButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.didSelectLevel(level: .friend)
        }
    }
}
