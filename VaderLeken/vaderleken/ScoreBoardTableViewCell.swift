//
//  ScoreBoardTableViewCell.swift
//  VaderLeken
//
//  Created by Phille on 2019-03-29.
//  Copyright © 2019 Phille. All rights reserved.
//

import UIKit

class ScoreBoardTableViewCell: UITableViewCell {
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var PlaceLabel: UILabel!
    
    func showScore(score: Double, place: Int){
        ScoreLabel.text = String(score)
        PlaceLabel.text = String(place)
    }
 

}
