//
//  ViewController.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-08.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import UIKit

// use search bar delegate and set keyboard with search button!
class ViewController: UIViewController{
    
    var cities = [City]()
    var favorites: FavoritesStore!

    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.keyboardType = .asciiCapable
        searchController.searchBar.delegate = self
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

extension ViewController: UISearchBarDelegate{
    // use searchbuttonclicked method instead of updatesearchresutls!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        searchForCities(searchTerm: text)
    }
    
    // make the call when the search button is clicked and fill the table!
    func searchForCities(searchTerm:String){
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(searchTerm)") else {return}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            data, response, error in
                if let actualData = data {
                    guard let decodedInstance = try? JSONDecoder().decode([City].self, from: actualData) else {return}
                    DispatchQueue.main.async {
                        self.cities = decodedInstance
                        self.tableView.reloadData()
                    }
                }
            })
            task.resume()
        }
    
    //use didselect row to get weather for the city. and save the entire weeks weather in an array!
    // check if i can perform segue in the didselect row method!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row].title
        return cell
    }
}

