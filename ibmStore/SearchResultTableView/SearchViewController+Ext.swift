//
//  SearchViewController+Ext.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/27/21.
//

import UIKit


// MARK:- Tableview DataSource and Delegate methods
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedApp = SearchResultswithImagesManager.shared.resultsWithImagesLoaded[indexPath.row]
        self.performSegue(withIdentifier: "goToAppDetailVC", sender: nil)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultswithImagesManager.shared.resultsWithImagesLoaded.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell") as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.app = SearchResultswithImagesManager.shared.resultsWithImagesLoaded[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userReachedEndOfTableview = indexPath.row + 1 == SearchResultswithImagesManager.shared.resultsWithImagesLoaded.count
        
        if userReachedEndOfTableview {
            print("User reached end of tableview")
            
            // check to see if there are more search results (apps) to load
            let indexOfLastLoadedResult = SearchResultswithImagesManager.shared.getIndexofLastLoadedResult()
            
            
            guard let filter = filter else { return }
            
            var totalResults = 0
            var resultsToPresent: [App] = []
            if filter.filterState == .unfiltered {
                resultsToPresent = SearchResultswithImagesManager.shared.results
                totalResults = resultsToPresent.count
            } else {
                resultsToPresent = SearchResultswithImagesManager.shared.filteredResults
                totalResults = resultsToPresent.count
            }
            
            if indexOfLastLoadedResult < totalResults {
                updateUIForLoadingSearch()
                SearchResultswithImagesManager.shared.loadResultImages(results: resultsToPresent)
            }
        }
    }
    
}

// MARK:- UITextFieldDelegate methods
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

