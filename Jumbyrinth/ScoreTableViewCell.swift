//
//  ScoreTableViewCell.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

// A table view cell used in the leaderboard.
class ScoreTableViewCell: UITableViewCell {

    // A label that displays the score (the amount of the time used to complete the game).
    @IBOutlet weak var scoreLabel: UILabel!
    // A label that displays the date on which the score record is created.
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
