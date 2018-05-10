//
//  DetailViewController.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-08.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import Foundation
import UIKit

struct SessionResult: Codable {
    var consolidated_weather: [Weather]
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var detailCity:City!
    var weekWeather:[Weather]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getWeatherDataFor(id: detailCity.woeid)
    }
    
    func getWeatherDataFor(id: Int){
        guard let url = URL(string: "https://www.metaweather.com/api/location/\(id)/") else { return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error == nil, data != nil {
                if let decodedInstance = try? JSONDecoder().decode(SessionResult.self, from: data!){
                   self.weekWeather = decodedInstance.consolidated_weather
                } else {
                    print(error?.localizedDescription)
                }
            }
        })
        task.resume()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weekWeather != nil {
            return  weekWeather.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        if weekWeather != nil {
            let f = DateFormatter()
            if let date = DateFormatter().date(from:  weekWeather[indexPath.row].applicable_date){
                cell.textLabel?.text = f.weekdaySymbols[Calendar.current.component(.weekday, from: date)]
            }
            
            cell.detailTextLabel?.text = Measurement(value:  weekWeather[indexPath.row].the_temp, unit: UnitTemperature.celsius).description
        }
        return cell
    }
}
