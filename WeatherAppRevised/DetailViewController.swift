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
    //can be instantiated!
    var weekWeather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherDataFor(id: detailCity.woeid)
    }
    
    func getWeatherDataFor(id: Int){
        guard let url = URL(string: "https://www.metaweather.com/api/location/\(id)/") else { return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error == nil, data != nil {
                if let decodedInstance = try? JSONDecoder().decode(SessionResult.self, from: data!){
                    DispatchQueue.main.async {
                   self.weekWeather = decodedInstance.consolidated_weather
                        self.tableView.reloadData()
                    }
                } else {
                    print(error?.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  weekWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.text = weekWeather[indexPath.row].applicable_date
        cell.detailTextLabel?.text = "\(String(describing: numberFormatter.string(from: NSNumber(value: weekWeather[indexPath.row].the_temp))!))°C"
        
        return cell
    }
    
    var numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 0
        return nf
    }()
}
