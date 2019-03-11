//
//  AnswersTableViewCell.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-11.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var AnswerLabel: UILabel!
    func displayAnswers(answers: String){
        AnswerLabel.text = answers
    }
    
}
