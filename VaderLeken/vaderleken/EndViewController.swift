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
    var answers: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension EndViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (answers?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersTableViewCell") as! AnswersTableViewCell
        cell.displayAnswers(answers: answer ?? "Fel")
        return cell
    }
}
