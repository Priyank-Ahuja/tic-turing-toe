//
//  GameButton.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/2/24.
//

import UIKit

class GameButton: UIButton {

    override init(frame: CGRect) {
            super.init(frame: frame)
            setupButton()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupButton()
        }
        
        private func setupButton() {
            // Set the corner radius
            //self.layer.cornerRadius =
            self.backgroundColor = Constants.color.backgrroundColor
                        
            // Set the tint color (for button text or image)
            self.tintColor = Constants.color.labelTintColor
            
            // Optional: Set title color
            self.setTitleColor(Constants.color.labelTintColor, for: .normal)
            
            self.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        }
    
    func setButtonTitle(title: String) {
        self.setTitle(title, for: .normal)
    }
}
