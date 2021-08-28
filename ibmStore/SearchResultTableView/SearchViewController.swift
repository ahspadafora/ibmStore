//
//  ViewController.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import UIKit

class SearchViewController: UIViewController, SearchResultswImagesDelegate {
    // MARK:- IBOutlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var emptyTableView: EmptyTableView!
    
    @IBOutlet weak var filteredByLabel: UILabel!
    
    // MARK:- Properties
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var filter: SearchResultsFilter? = nil
    var selectedApp: App?
    
    // MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIntroView()
        setUpCustomSearchButton()
        
        // delegate pattern used to notify view controller that imageDownloading has completed
        SearchResultswithImagesManager.shared.delegate = self
        
        filter = SearchResultsFilter(priceFilter: .all)
    }
    
    // MARK:- SearchResultswImagesDelegate methods
    /**
     SearchResultswImages Delegate method that is called when SearchResultswithImagesManager has finished downloading the result Images
     */
    func imageDownloadComplete() {
        DispatchQueue.main.async {
            self.searchResultsTableView.reloadData()
            self.activityIndicator.stopAnimating()
            if SearchResultswithImagesManager.shared.resultsWithImagesLoaded.count == 0 {
                self.updateUIForCompletedSearch(successful: false, error: nil)
            } else {
                self.updateUIForCompletedSearch(successful: true, error: nil)
            }
        }
    }
    
    // MARK:- Helper Methods
    /**
     A method that displays the emptyTableView and hides the searchResultsTableView
     
     */
    func setUpIntroView() {
        emptyTableView.imageView.image = UIImage(named: "emptySearch")
        emptyTableView.messageLabel.text = "Search for apps by entering a searchterm and pressing the magnifying glass. Example: Sudoku"
        emptyTableView.isHidden = false
        searchResultsTableView.isHidden = true
    }
    func setUpCustomSearchButton() {
        searchButton.setImage(UIImage(named: "searchselected"), for: .highlighted)
        searchButton.setImage(UIImage(named: "searchselected"), for: .selected)
    }
    

    /**
     A method that hides the searchResultsTableView if unhidden, adds an activityViewIndicator to the view, and disables the search button
     - parameter sender: UIButton that was pressed to initiate API call
     */
    func updateUIForLoadingSearch() {
        searchResultsTableView.isHidden = true
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.blue
        activityIndicator.startAnimating()
        
        // temporarily disable search button while loading results to prevent the user from making multiple request at once
        searchButton.isEnabled = false
    }
    
    /**
     A method that either displays the searchTableView with results, or displays the emptyTableview with a message, depending on the successful parameter; when successful = false this method will stop animating the activityIndicator
     - parameter successful: returns true if iTunes Store API call returned more than 1 result, false if returned 0 results or an error
     - parameter error: Error returned by iTunesStore API call
     
     */
    private func updateUIForCompletedSearch(successful: Bool, error: Error?) {
        DispatchQueue.main.async {
            self.searchButton.isEnabled = true
            if successful {
                self.searchResultsTableView.isHidden = false
                self.emptyTableView.isHidden = true
            } else {
                var message = ""
                if let error = error {
                    message = error.localizedDescription
                } else {
                    message = "We're sorry, we are unable to find results for that search term"
                }
                self.searchResultsTableView.isHidden = true
                self.emptyTableView.isHidden = false
                self.emptyTableView.imageView.image = UIImage(named: "noResultSearch")
                self.emptyTableView.messageLabel.text = message
                self.activityIndicator.stopAnimating()
            }
        }
    }
    /**
     A method that initializes and presents a UIAlertController with the passed in error. Also stops activity indicator from animating
     - parameter error: error to present
     
     */
    private func presentErrorAlert(error: Error?) {
        guard let error = error else { return }
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: "Error Occurred", message: error.localizedDescription, preferredStyle: .alert)
            self.present(alertView, animated: true) {
                self.activityIndicator.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    alertView.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Prepare for seguee
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchTextField.resignFirstResponder()
        if segue.identifier == "goToFilterVC" {
            let destinationVC = segue.destination as? FilterViewController
            destinationVC?.searchFilter = self.filter
        }
        
        if segue.identifier == "goToAppDetailVC" {
            let destinationVC = segue.destination as? AppDetailViewController
            destinationVC?.appToDisplay = self.selectedApp
        }
    }
    
    // MARK:- IBActions
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let searchTerm = self.searchTextField.text else {
            print("unable to unwrap searchTerm from SearchViewController.searchTextField")
            return
        }
        
        updateUIForLoadingSearch()
        
        iTunesApiManager.shared.getSearchResults(for: searchTerm, limit: 200) { (data, error)  in
            let jsonDecoder = JSONDecoder()
            do {
                guard let validData = data else {
                    self.presentErrorAlert(error: error)
                    self.updateUIForCompletedSearch(successful: false, error: error)
                    return
                }
                let apiResults = try jsonDecoder.decode(iTunesSearchAPIResult.self, from: validData)
                if apiResults.results.count == 0 {
                    self.updateUIForCompletedSearch(successful: false, error: nil)
                    return
                }
                guard let filter = self.filter else {
                    return
                }
                
                if filter.filterState == .unfiltered {
                    SearchResultswithImagesManager.shared.results = apiResults.results
                } else {
                    // filter by category
                    let filteredResultsByCategory = apiResults.results.filter { (app) -> Bool in
                        
                        if let appCategory = SearchResultsFilter.AppCategory.init(rawValue: app.category) {
                            return filter.selectedAppCategories[appCategory] ?? false
                        }
                        return false
                    }
                    print("FilterByCategory.count = \(filteredResultsByCategory.count)")
                    // then filter by price
                    let filteredByCategoryAndPrice = filteredResultsByCategory.filter { (app) -> Bool in
                        
                        if let appPriceString = app.formattedPrice {
                            let priceFilter = filter.priceFilter
                            
                            switch priceFilter {
                            case .all:
                                return true
                            case .free:
                                if appPriceString.contains("e") { return true } else { return false }
                            case .paid:
                                if appPriceString.contains("$") { return true } else { return false }
                            }
                        } else {
                            print(app.formattedPrice ?? "no formatted price for \(app.appTitle)")
                            print(app.price ?? "no formatted price for \(app.appTitle)")
                            return true
                        }
                    }
                    print("FilteredByPrice&Category.count = \(filteredByCategoryAndPrice.count)")
                    SearchResultswithImagesManager.shared.filteredResults = filteredByCategoryAndPrice
                }
            }
            catch {
                print(error)
                self.updateUIForCompletedSearch(successful: false, error: nil)
            }
        }
    }
}


