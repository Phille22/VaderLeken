//
//  EasyGameViewController.swift
//  VaderLeken
//
//  Created by user149351 on 2019-03-07.
//  Copyright © 2019 STI. All rights reserved.
//

import UIKit
import MapKit

struct WeatherResponse: Decodable{
    let value: [Value]
    let station: Station
}

struct ForecastResponse: Decodable{
    let timeSeries: [TimeSeries]
    
}

struct Value: Decodable{
    let value: String
}

struct Station: Decodable{
    let name: String
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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var CurrentTempButton: UIButton!
    
    @IBOutlet weak var FalseTempButton: UIButton!
    
    @IBOutlet weak var FalseTempButton2: UIButton!
    @IBOutlet weak var StationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = randomLocation()
        getWeather(latitude: location.1, longitude: location.2){ (theData) in
            let temperatures = self.getTemperature(with: theData)
            self.showTemperature(realTemp: temperatures.0, randNumber: temperatures.1, randNumber2: temperatures.2)
        }
        displayMap(latitude: location.1, longitude: location.2, location: location.0)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func RealTempPress(_ sender: Any) {
        let location = randomLocation()
        getWeather(latitude: location.1, longitude: location.2){ (theData) in
            let temperatures = self.getTemperature(with: theData)
            self.showTemperature(realTemp: temperatures.0, randNumber: temperatures.1, randNumber2: temperatures.2)
        }
        displayMap(latitude: location.1, longitude: location.2, location: location.0)
    }
    
    
    //Välj en slumpmässig plats på kartan
    func randomLocation() -> (CLLocation, Double, Double){
        let lat2 = Double.random(in: 55.354135...68.815927)
        let long2 = Double.random(in: 12.801269...23.941405)
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
    
    //Hämta temperaturdata
    func getTemperature(with responseData: ForecastResponse) -> (Double, Double, Double){
        let realTemp = responseData.timeSeries[1].parameters[11].values[0]
        print(realTemp)
        let randNumber = Double.random(in: (realTemp-10.0)...(realTemp+10.0))
        let randNumber2 = Double.random(in: (realTemp-10.0)...(realTemp+10.0))
        print(randNumber)
        print(randNumber2)
       return(realTemp, randNumber, randNumber2)
    }
    
    //Visa temperaturen på knapparna
    func showTemperature(realTemp: Double, randNumber: Double, randNumber2: Double){
        DispatchQueue.main.async {
           // self.CurrentTempButton.titleLabel?.text = String(realTemp)
           // self.FalseTempButton.titleLabel?.text = String(randNumber)
           // self.FalseTempButton2.titleLabel?.text = String(randNumber2)
            self.CurrentTempButton.setTitle(String(realTemp), for: .normal)
            self.FalseTempButton.setTitle(String(randNumber), for: .normal)
            self.FalseTempButton2.setTitle(String(randNumber2), for: .normal)
        }
    }
    
    //Kartan
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
                }
            
        })
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
