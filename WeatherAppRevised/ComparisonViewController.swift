//
//  ComparisonViewController.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-11.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import UIKit

class ComparisonViewController: UITableViewController {
    
    var selectedCities = [City]()
    var weather = [Weather]()
    var images = [UIImage]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        if weather.count != 0{
        getImages()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comparisonCell", for: indexPath) as! TableViewCell
        let city = selectedCities[indexPath.row]
        cell.cityNameLabel.text = city.title
        cell.temperatureLabel.text = String(weather[indexPath.row].the_temp)
        cell.weatherImage.image = images[indexPath.row]
        return cell
    }
    
    func getWeather(){
        for city in selectedCities{
            let urlRequest = URLRequest(url: URL(string: "https://www.metaweather.com/api/location/\(city.woeid)")!)
            let task = URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                if error == nil, let actualData = data {
                    DispatchQueue.main.async {
                        let decodedInstance = try? JSONDecoder().decode(SessionResult.self, from: actualData)
                        self.weather.append(decodedInstance!.consolidated_weather[0])
                        }
                    }
            }
            task.resume()
        }
    }
    
    func getImages(){
        for city in weather{
            let urlRequest = URLRequest(url: URL(string:"https://www.metaweather.com/static/img/weather/png/64/\(city.weather_state_abbr).png" )!)
            let task = URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                if error == nil, let actualData = data{
                    self.images.append(UIImage(data: actualData)!)
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
}
