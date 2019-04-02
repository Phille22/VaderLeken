 //
//  EndViewController.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-11.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CorrectAnswersLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!
    
    
    var answers: [String]?
    var cities: [String]?
    var rightTemps: [Double]?
    var correctAnswers: Int?
    var points: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CorrectAnswersLabel.text = "\(correctAnswers ?? 0) Av 5"
        PointsLabel.text = "\(points ?? 0) Poäng"
    }
}

extension EndViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (answers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers?[indexPath.row]
        let city = cities?[indexPath.row]
        let rightTemp = rightTemps?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersTableViewCell") as! AnswersTableViewCell
        cell.displayAnswers(answers: answer ?? "Ingen data", cities: city ?? "Ingen data", rightTemps: Double(rightTemp ?? 0))
        if (answer == "\(rightTemp ?? 0)"){
            cell.backgroundColor = UIColor.green
        }else{
           cell.backgroundColor = UIColor.red
        }
        return cell
    }
}
