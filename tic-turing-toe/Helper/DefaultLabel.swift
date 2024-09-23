//
//  CustomLabel.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 9/22/24.
//

import UIKit

class DefaultLabel: UILabel {

    override init(frame: CGRect) {
            super.init(frame: frame)
            setupLabel()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupLabel()
        }
        
        private func setupLabel() {
            self.textColor = Constants.color.labelTintColor
        }
}
