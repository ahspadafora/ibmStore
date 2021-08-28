//
//  iTunesApiSearchResult.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import Foundation

struct iTunesSearchAPIResult: Codable {
    var results: [App]
}

struct App: Codable {
    enum CodingKeys: String, CodingKey {
        case averageUserRating, screenshotUrls, trackId, formattedPrice, description, price
        case appTitle = "trackName"
        case category = "primaryGenreName"
        case appIcon100 = "artworkUrl100"
        case appIcon60 = "artworkUrl60"
        case appIcon512 = "artworkUrl512"
        case size = "fileSizeBytes"
    }
    var averageUserRating: Float
    
    // trackName
    var appTitle: String
    
    var screenshotUrls: [String]
    var category: String
    
    var appIcon100: String
    var appIcon60: String
    var appIcon512: String
    var trackId: Int64
    var description: String
    var formattedPrice: String?
    var price: Float?
    var size: String?
}
