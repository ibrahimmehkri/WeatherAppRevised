//
//  FavoritesViewController.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-10.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favorites: FavoritesStore!
    var selectedCities = [City]()
    var weather = [Weather]()
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath)
        cell.textLabel?.text = favorites.favoritesArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = favorites.favoritesArray[indexPath.row]
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
           selectedCities = selectedCities.filter({$0.title != city.title})
            for item in selectedCities{
                print(item.title)
            }
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedCities.append(city)
            for item in selectedCities{
                print(item.title)
            }
        }
    }
    @IBAction func gotoComparisonScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "toComparisonScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComparisonScreen"{
            let controller = segue.destination as! ComparisonViewController
            controller.selectedCities = selectedCities
        }
    }
    

}
