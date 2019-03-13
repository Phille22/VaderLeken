//
//  DifficultyViewController.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-13.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController {
    
    var EasyOrHard: Bool?
    
    @IBOutlet weak var EasyButton: UIButton!
    @IBOutlet weak var HardButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
