//
//  SearchFilter.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/26/21.
//

import Foundation

/**
 A class that stores filter settings
 -  filterState: an enum with two cases .unfiltered and .filtered, when priceFilter is .all and selectedAppCategores[.All] == true, this will be set to .filtered. This is always set to .unfiltered on init
 -  AppCategory: an enum that stores all app categories and conforms to String and CaseIterable protocl
 -  selectedAppCategories: a dictionary of type [AppCategory: Bool] where selectedAppCategories[appCategory] == true means that app category is currently selected
 - PriceFilterType: an enum that has three cases .all, .paid, and .free to filter search results
 - priceFilter: a variable of type PriceFilterType that determines whether to show .all, .paid, or .free apps
 */
class SearchResultsFilter {
    
    enum AppCategory: String, CaseIterable {
        case All,
        Apple_Watch_Apps = "Apple Watch Apps",
        AR_Apps = "AR Apps",
        Book,
        Business,
        Developer_Tools = "Developer Tools",
        Education,
        Entertainment,
        Finance,
        Food_Drink = "Food & Drink",
        Graphics_Design = "Graphics & Design",
        Games,
        Health_Fitness = "Health & Fitness",
        Kids,
        Lifestyle,
        Magazines_Newspapers = "Magazines & Newspapers",
        Medical,
        Music,
        Navigation,
        News,
        Photo_Video = "Photo & Video",
        Productivity,
        Reference,
        Shopping,
        Social_Networking = "Social Networking",
        Sports,
        Travel,
        Utilities,
        Weather
    }
    
    enum FilterState {
        case unfiltered, filtered
    }
    var selectedAppCategories: [AppCategory: Bool] = {
        // defaults all app categories to deselected, except 'All'
        var temp: [AppCategory: Bool] = [:]
        AppCategory.allCases.forEach { (appCategory) in
            // defaults all categories to true (selected) (will present every genre)
            temp[appCategory] = true
        }
        return temp
    }()
    
    
    enum PriceFilterType: String, CaseIterable {
        case all, free, paid
    }
    var priceFilter: PriceFilterType = .all
    
    init(priceFilter: PriceFilterType, filterState: FilterState = .unfiltered){
        self.priceFilter = priceFilter
    }
    var filterState: FilterState = .unfiltered
    
}
