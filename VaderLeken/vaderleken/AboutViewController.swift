//
//  AboutViewController.swift
//  VaderLeken
//
//  Created by Phille on 4/15/19.
//  Copyright © 2019 Phille. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var imageLinkButton: UIButton!
    
    @IBOutlet weak var licenceLinkButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        //Anpassar knapparnas storlek för att passa skärmstorlek
    imageLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
        licenceLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Öppna URL
    @IBAction func LicenceLink(_ sender: Any) {
        if let url = URL(string: "https://creativecommons.org/licenses/by-sa/3.0/deed.en"){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    @IBAction func imageLink(_ sender: Any) {
        if let url = URL(string: "https://commons.wikimedia.org/wiki/File:RainAmsterdamTheNetherlands.jpg"){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
