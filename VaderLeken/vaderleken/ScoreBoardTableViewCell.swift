//
//  ScoreBoardTableViewCell.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-29.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell {
    @IBOutlet weak var ScoreLabel: UILabel!
    
    func showScore(score: Double){
        ScoreLabel.text = String(score)
    }
 

}
