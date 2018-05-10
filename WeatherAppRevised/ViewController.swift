//
//  ViewController.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-08.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import UIKit

// use search bar delegate and set keyboard with search button!
class ViewController: UIViewController {
    
    var cities = [City]()

    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Search"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.isActive = true
    }
}

enum CitySearch{
    case success([City])
    case failure(Error)
}
enum WeatherResult{
    case success([Weather])
    case failure(Error)
}
struct City: Codable{
    var title:String
    var location_type:String
    var woeid:Int
}
struct Weather: Codable {
    var applicable_date: String
    var the_temp:Double
}



extension ViewController: UISearchResultsUpdating{
    // use searchbuttonclicked method instead of updatesearchresutls!
    func updateSearchResults(for searchController: UISearchController) {
        searchForCities(searchTerm: searchController.searchBar.text!)
    }
    
    // make the call when the search button is clicked and fill the table!
    func searchForCities(searchTerm:String){
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(searchTerm)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
                if let actualData = data {
                        let decodedInstance = try? JSONDecoder().decode([City].self, from: actualData)
                    self.cities = decodedInstance!
                }
            })
            task.resume()
            self.tableView.reloadData()
        }
    
    //use didselect row to get weather for the city. and save the entire weeks weather in an array!
    // check if i can perform segue in the didselect row method! 
     func getWeatherDataFor(id: Int, completion: @escaping (WeatherResult)->Void){
        guard let url = URL(string: "https://www.metaweather.com/api/location/\(id)/") else { return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
            if error == nil, data != nil {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: [])
                guard let jsonDictionary = jsonObject as? [AnyHashable:Any],
                    let weatherForecast = jsonDictionary["consolidated_weather"] as? Data else { return}
                
                if let decodedInstance = try? JSONDecoder().decode([Weather].self, from: weatherForecast){
                    completion(.success(decodedInstance))
                } else {
                    completion(.failure(error!))
                }
            }
        })
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView"{
            let index = tableView.indexPathForSelectedRow?.row ?? 0
            let city = cities[index]
            let controller = segue.destination as! DetailViewController
            controller.detailCity = city
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].title
        return cell
    }
}

