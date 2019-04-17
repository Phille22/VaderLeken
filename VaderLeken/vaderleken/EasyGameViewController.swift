//
//  EasyGameViewController.swift
//  VaderLeken
//
//  Created by Phille on 2019-03-07.
//  Copyright © 2019 Phille. All rights reserved.
//

import UIKit
import MapKit
import CoreData

//Väderdatan
struct ForecastResponse: Decodable{
    let timeSeries: [TimeSeries]
    
}

struct TimeSeries: Decodable{
    let parameters: [Parameters]
}

struct Parameters: Decodable{
    let values: [Double]
}

struct Values: Decodable{
    let values: Int
}


class EasyGameViewController: UIViewController {
    var rightAnswer = 0 //Hur många gånger användaren har svarat rätt
    var numberOfAnswers = 0 //Hur många gånger användaren har gissat
    var points = 0.0 //Antal poäng
    var tempList: [Double] = [] //Tillfällig array med temperaturer för den plats som användaren gissar på, rensas efter varje svar
    var answerList: [String] = [] //Användarens svar
    var cityList: [String] = [] //Städerna som man gissar temperatuen på
    var rightTempList: [Double] = [] //Rätt temperatur
    var easyOrHard: Bool? //Lätt eller svår svårighetsgrad
    
    @IBOutlet weak var mapView: MKMapView! //Kartan
    @IBOutlet weak var TempButton1: UIButton! //Temperaturknapp 1
    @IBOutlet weak var TempButton2: UIButton! //Temperaturknapp 2
    @IBOutlet weak var TempButton3: UIButton! //Temperaturknapp 3
    @IBOutlet weak var StationLabel: UILabel! //Stadsnamnet
    @IBOutlet weak var AnswerTextField: UITextField! //Rutan för att fylla i temperatur
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Om man spelar på svår svårighetsgrad
        if easyOrHard == false{
            TempButton1.isHidden = true
            TempButton3.isHidden = true
            AnswerTextField.becomeFirstResponder()
        }else{
            //Göm rutan för egen inmatning av temperatur om man spelar på lätt svårighetsgrad
         AnswerTextField.isHidden = true
        }
        let location = randomLocation()
        getWeather(latitude: location.1, longitude: location.2){ (theData) in
            let temperatures = self.getTemperature(with: theData)
            self.showTemperature(realTemp: temperatures.0, randNumber: temperatures.1, randNumber2: temperatures.2)
        }
        displayMap(latitude: location.1, longitude: location.2, location: location.0)
    }
    //Action för första knappen
    @IBAction func TempButton1Press(_ sender: Any) {
        if numberOfAnswers <= 4{
        if TempButton1.titleLabel?.text == String(tempList[0]){
           rightAnswer += 1
            points += 100 //100 poäng för rätt svar
            print(rightAnswer)
        }else{
            points += 10 - (tempList[0] - Double("\(TempButton1.titleLabel?.text ?? "0")")!).magnitude
            }
        numberOfAnswers += 1
        answerList.append((TempButton1.titleLabel?.text)!)
        tempList.removeAll()
        viewDidLoad()
            if numberOfAnswers == 5{ //Sluta spelet efter fem spelade omgångar
                performSegue(withIdentifier: "EndGame", sender: self)
            }
        }
    }
    //Action för andra knappen
    @IBAction func TempButton2Press(_ sender: Any) {
        if numberOfAnswers <= 4{
            //Om man spelar på svår svårighetsgrad
            if easyOrHard == false{
                if AnswerTextField.text == String(tempList[0]){
                    rightAnswer += 1
                    points += 200 //Dubbelt så mycket poäng för rätt svar än om man spelar på lätt svårighetsgrad
                }else{
                    points += 20 - (tempList[0] - Double("\(AnswerTextField.text ?? "0")")!).magnitude
                }
                answerList.append((AnswerTextField?.text)!)
                AnswerTextField.text = ""
            }else{
                if TempButton2.titleLabel?.text == String(tempList[0]){
                    rightAnswer += 1
                    points += 100
                    print(rightAnswer)
                }else{
                    points += 10 - (tempList[0] - Double("\(TempButton2.titleLabel?.text ?? "0")")!).magnitude
                }
                answerList.append((TempButton2.titleLabel?.text)!)
            }
        numberOfAnswers += 1
        tempList.removeAll()
        viewDidLoad()
            if numberOfAnswers == 5{
                performSegue(withIdentifier: "EndGame", sender: self)
            }
        }
    }
    //Action för tredje knappen
    @IBAction func TempButton3Press(_ sender: Any) {
        if numberOfAnswers <= 4{
        if TempButton3.titleLabel?.text == String(tempList[0]){
            rightAnswer += 1
            points += 100
        }else{
            points += 10 - (tempList[0] - Double("\(TempButton3.titleLabel?.text ?? "0")")!).magnitude
            }
        numberOfAnswers += 1
        answerList.append((TempButton3.titleLabel?.text)!)
        tempList.removeAll()
        viewDidLoad()
            if numberOfAnswers == 5{
                performSegue(withIdentifier: "EndGame", sender: self)
            }
        }
    }
    //Skicka data till skärm med sammanfattning
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EndGame"{
            let endView = segue.destination as! EndViewController
            endView.answers = answerList
            endView.cities = cityList
            endView.rightTemps = rightTempList
            endView.correctAnswers = rightAnswer
            endView.points = points.rounded()
            
            //Spara datan i Core Data
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let saveData = SaveDataCoreData(context: appDelegate.persistentContainer.viewContext)
                saveData.correctAnswers = Int16(rightAnswer)
                saveData.answer = answerList[0]
                saveData.answer2 = answerList[1]
                saveData.answer3 = answerList[2]
                saveData.answer4 = answerList[3]
                saveData.answer5 = answerList[4]
                saveData.city = cityList[0]
                saveData.city2 = cityList[1]
                saveData.city3 = cityList[2]
                saveData.city4 = cityList[3]
                saveData.city5 = cityList[4]
                saveData.rightTemp = rightTempList[0]
                saveData.rightTemp2 = rightTempList[1]
                saveData.rightTemp3 = rightTempList[2]
                saveData.rightTemp4 = rightTempList[3]
                saveData.rightTemp5 = rightTempList[4]
                saveData.points = points
                appDelegate.saveContext()
            }
            }
        }
    
    
    //Välj en slumpmässig plats på kartan
    func randomLocation() -> (CLLocation, Double, Double){
        let lat2 = Double.random(in: 57.354135...65.815927)
        let long2 = Double.random(in: 13.801269...15.371093)
        let initialLocation = CLLocation(latitude: lat2, longitude: long2)
        return (initialLocation, lat2, long2)
    }
    //Hämta väderdata
    func getWeather(latitude: Double, longitude: Double, completion: @escaping (ForecastResponse) -> Void){
        let latRound = Double(round(1000 * latitude)/1000)
        let longRound = Double(round(1000 * longitude)/1000)
        //let jsonUrlString = "https://opendata-download-metobs.smhi.se/api/version/latest/parameter/1/station/97400/period/latest-hour/data.json"
        let jsonUrlString = "https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/\(longRound)/lat/\(latRound)/data.json"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data
            , response
            , err) in
            
            guard let data = data else { return }
            
            do{
                let responseData = try JSONDecoder().decode(ForecastResponse.self, from: data)
                
                completion(responseData)
                
            } catch let jsonErr {
                print("Det gick inte att serialiera json", jsonErr)
            }
            }.resume()
    }
    //Hämta temperaturdata från väderdatan
    func getTemperature(with responseData: ForecastResponse) -> (Double, Double, Double){
        let realTemp = responseData.timeSeries[1].parameters[11].values[0]
        let randNumber = Double.random(in: (realTemp-10.0)...(realTemp+10.0))
        let randNumber2 = Double.random(in: (realTemp-10.0)...(realTemp+10.0))
        let roundedNumber = Double(round(10*randNumber)/10)
        let roundedNumber2 = Double(round(10*randNumber2)/10)
        tempList.append(contentsOf: [realTemp, roundedNumber, roundedNumber2])
        rightTempList.append(realTemp)
        return(realTemp, roundedNumber, roundedNumber2)
    }
    
    //Visa temperaturen på knapparna
    func showTemperature(realTemp: Double, randNumber: Double, randNumber2: Double){
        DispatchQueue.main.async {
            var temporaryList = [realTemp, randNumber, randNumber2]
            temporaryList.shuffle() //Slumpmässig ordning på knapparna
            self.TempButton1.setTitle(String(temporaryList[0]), for: .normal)
            if self.easyOrHard == false{
                self.TempButton2.setTitle("Ok", for: .normal) //Gör om knappen till en Ok-knapp om svårt spel spelas
            }else{
                self.TempButton2.setTitle(String(temporaryList[1]), for: .normal)
            }
            self.TempButton3.setTitle(String(temporaryList[2]), for: .normal)
            temporaryList.removeAll()
        }
    }
    
    // Visa kartan
    func displayMap(latitude: Double, longitude: Double, location: CLLocation){
        let regionRadius: CLLocationDistance = 500000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        let place = MKPointAnnotation()
        place.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(place)
        
        //Hämta adress från koordinater
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:
            {
            placemarks, error -> Void in
                
                guard let placeMark = placemarks?.first else {return}
                
                if let city = placeMark.locality{
                    self.StationLabel.text = city
                    self.cityList.append(city)
                }
            
        })
    }
}
