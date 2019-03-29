//
//  ScoreBoardViewController.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-29.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit
import CoreData

class ScoreBoardViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var resultsArray: [SaveDataCoreData] = []
    var fetchResultController: NSFetchedResultsController<SaveDataCoreData>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //skicka rätt data att visa
        if segue.identifier == "showResult"{
            if let resultPage = segue.destination as? EndViewController{
                if let index = sender as? Int{
                    let answers = [resultsArray[index].answer, resultsArray[index].answer2, resultsArray[index].answer3, resultsArray[index].answer4, resultsArray[index].answer5]
                    let cities = [resultsArray[index].city, resultsArray[index].city2, resultsArray[index].city3, resultsArray[index].city4, resultsArray[index].city5]
                    let rightTemps = [resultsArray[index].rightTemp, resultsArray[index].rightTemp2, resultsArray[index].rightTemp3, resultsArray[index].rightTemp4, resultsArray[index].rightTemp5]
                    
                    resultPage.answers = answers as? [String]
                    resultPage.cities = cities as? [String]
                    resultPage.rightTemps = rightTemps
                    resultPage.correctAnswers = Int(resultsArray[index].correctAnswers)
                }
            }
        }
    }
    
    //Ladda data
    override func viewWillAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<SaveDataCoreData> = SaveDataCoreData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "correctAnswers", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    resultsArray = fetchedObjects
                }
            }catch{
                print(error)
            }
        }
        
    }

}

extension ScoreBoardViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let results = resultsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreBoardTableViewCell") as! ScoreBoardTableViewCell
        cell.showScore(score: Int(results.correctAnswers))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        performSegue(withIdentifier: "showResult", sender: row)
    }
    
}
