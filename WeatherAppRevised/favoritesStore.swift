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
    var favorites = [City]()
    
    func includeInFavorites(city: City) {
        favorites.append(city)
    }
}
