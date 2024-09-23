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
        self.navigationController?.present(SettingsViewController(), animated: true)
    }
}
