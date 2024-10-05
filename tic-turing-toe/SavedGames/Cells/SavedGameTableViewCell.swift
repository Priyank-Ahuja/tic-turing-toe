//
//  SavedGameTableViewCell.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/4/24.
//

import UIKit

class SavedGameTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var snoLabel: DefaultLabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupInterface(model: SavedGameCellModel) {
        self.dateLabel.text = model.dateString
        self.modeLabel.text = model.game?.mode
        self.winnerLabel.text = model.game?.winner
        self.snoLabel.text = model.sno
    }
    
    func setupInterface() {
        self.snoLabel.text = "GNo"
        self.modeLabel.text = "Difficulty"
        self.winnerLabel.text = "Winner"
        self.dateLabel.text = "Date"
    }
    
}
