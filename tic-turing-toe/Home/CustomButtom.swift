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
            self.backgroundColor = Constants.Color.ButtonBackgroundColor
            
            // Set the tint color (for button text or image)
            self.tintColor = Constants.Color.LabelTintColor
            
            // Optional: Set title color
            self.setTitleColor(Constants.Color.LabelTintColor, for: .normal)
            
            // Optional: Set a title for the button
            //self.setTitle("Custom Button", for: .normal)
            
            // Optional: Set font size for title
            //self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
}
