//
//  DifficultyViewController.swift
//  VaderLeken
//
//  Created by Phille on 2019-03-13.
//  Copyright © 2019 Phille. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var EasyOrHard: Bool?
    
    @IBOutlet weak var EasyButton: UIButton!
    @IBOutlet weak var HardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func EasyButtonPress(_ sender: Any) {
        EasyOrHard = true
        performSegue(withIdentifier: "StartGame", sender: self)
        
    }
    
    @IBAction func HardButtonPress(_ sender: Any) {
        EasyOrHard = false
        performSegue(withIdentifier: "StartGame", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame"{
            let startGameView = segue.destination as! EasyGameViewController
            startGameView.easyOrHard = EasyOrHard
        }
    }
}
