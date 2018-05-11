//
//  favoritesStore.swift
//  WeatherAppRevised
//
//  Created by Ibrahim Mehkri  on 2018-05-10.
//  Copyright © 2018 Ibrahim Mehkri . All rights reserved.
//

import Foundation
import UIKit

class FavoritesStore: NSObject{
    var favoritesArray = [City]()
    
    func includeInFavorites(city: City) {
        favoritesArray.append(city)
    }
}
