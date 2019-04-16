//
//  AnswersTableViewCell.swift
//  VaderLeken
//
//  Created by Phille on 2019-03-11.
//  Copyright © 2019 Phille. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AnswerLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var RightTempLabel: UILabel!
    
    func displayAnswers(answers: String, cities: String, rightTemps: Double){
        AnswerLabel.text = answers
        CityLabel.text = cities
        RightTempLabel.text = String(rightTemps)
    }
    
}
