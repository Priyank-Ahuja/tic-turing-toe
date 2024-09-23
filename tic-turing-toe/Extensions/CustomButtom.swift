//
//  CustomButtom.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 9/22/24.
//

import UIKit

class CustomButtom: UIButton {

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
            self.layer.cornerRadius = 10
            
            // Set the background color
            self.backgroundColor = Constants.color.buttonBackgroundColor
            
            // Set the tint color (for button text or image)
            self.tintColor = Constants.color.labelTintColor
            
            // Optional: Set title color
            self.setTitleColor(Constants.color.labelTintColor, for: .normal)
        }
}
