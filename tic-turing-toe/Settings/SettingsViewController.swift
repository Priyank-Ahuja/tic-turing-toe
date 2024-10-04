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
    
    @IBOutlet weak var friendButton: DefaultButton!
    
    var delegate: SettingsViewControllerDelegate?
    var viewModel: SettingsViewModel?
    
    init(model: SettingsViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        setupPresentationController()
        setupInterface()
    }
    
    func setupInterface() {
        switch viewModel?.source {
        case .home, .none:
            self.friendButton.isHidden = false
        case .game:
            self.friendButton.isHidden = true
        }
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
            self.delegate?.didSelectLevel(level: .bluetooth)
        }
    }
}
