//
//  iTunesApiManager.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import Foundation

class iTunesApiManager {
    
    static let shared = iTunesApiManager()
    /**
     A method that makes makes a urlRequest to the iTunes Search API and returns the retrieved data or error in an escaping closure
     */
    func getSearchResults(for term: String, limit: Int, callback: @escaping (Data?, Error?) -> ()) {
        
        guard let term = term.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else { return }
        
        if let iTunesSearchAPIEndpointURL = URL(string: "https://itunes.apple.com/search?term=\(term)&entity=software&limit=\(limit)") {
            let urlRequest = URLRequest(url: iTunesSearchAPIEndpointURL)

            URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    callback(nil, error)
                }

                if let validData = data {
                    callback(validData, nil)
                    print(validData)
                }

            }.resume()
        } else {
            print("unable to complete search")
            callback(nil, nil)
        }
        
    }
    
}
