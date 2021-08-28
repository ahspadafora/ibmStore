//
//  FilterViewController.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/26/21.
//

import UIKit

class FilterViewController: UIViewController {
    
    enum CostType: CaseIterable {
        case all, free, paid
    }
    
    var searchFilter: SearchResultsFilter?
    
    @IBOutlet weak var costFilterSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControlUIToCurrentSetting()
    }
    
    private func setupSegmentedControlUIToCurrentSetting() {
        var selectedIndex = 0
        switch searchFilter?.priceFilter {
        case .all:
            selectedIndex = 0
        case .free:
            selectedIndex = 1
        case .paid:
            selectedIndex = 2
        default:
            selectedIndex = 0
            
        }
        
        costFilterSegmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    @IBAction func costFilterUpdated(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex) {
        case "All":
            searchFilter?.priceFilter = .all
            self.searchFilter?.priceFilter = .all
            self.searchFilter?.filterState = .unfiltered
        case "Free":
            self.searchFilter?.priceFilter = .free
            self.searchFilter?.filterState = .filtered
        case "Paid":
            self.searchFilter?.priceFilter = .paid
            self.searchFilter?.filterState = .filtered
            
        default:
            return
        }
    }
}

extension FilterViewController: UITableViewDelegate {
    
    // updates the UI as well as updating the SearchResultsFilter object with the selected category(s)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCategory = SearchResultsFilter.AppCategory.allCases[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        // when case "All" is true (selected), all other categories are marked as true in selectedAppCategories, but show in UI accessoryType.none
        let conditionToNotToggle = (self.searchFilter?.selectedAppCategories[selectedCategory] == true) && cell?.accessoryType == UITableViewCell.AccessoryType.none
        
        //   if there is no checkmark present but the selected category is already marked true, then that means the user is 'deselecting' all, and selcting the specific category-  this is done so the UI shows only 'all' with a checkmark, although all categories are actually 'selected'
        
        // if 'all' is not selected, then toggle the selected category
        if !conditionToNotToggle {
            self.searchFilter?.selectedAppCategories[selectedCategory]?.toggle()
        }
        
        // update selected cells UI based on its categories state in selectedAppCategories
        cell?.accessoryType = self.searchFilter?.selectedAppCategories[selectedCategory]! ?? false ? .checkmark : .none
        
        let selectedCellWasDeselected = self.searchFilter?.selectedAppCategories[selectedCategory] == false
        
        // if selected category is "All" that all categories should be marked as true, however only the "all" cell will show a checkmark
        if selectedCategory == .All {
            self.searchFilter?.filterState = .unfiltered
            switch selectedCellWasDeselected {
            case true:
                self.searchFilter?.selectedAppCategories.forEach { (key, val) in
                    if key != .All {
                        self.searchFilter?.selectedAppCategories[key] = false
                    }
                }
            case false:
                self.searchFilter?.selectedAppCategories.forEach { (key, val) in
                    if key != .All {
                        self.searchFilter?.selectedAppCategories[key] = true
                    }
                }
            }
            tableView.reloadData()
            
            // otherwise, the user is selecting a single category so "all" will be marked as false, and all other categories will be set to "false" (only if "all" was true previously)
        } else {
            self.searchFilter?.filterState = .filtered
            if self.searchFilter?.selectedAppCategories[.All] == true {
                self.searchFilter?.selectedAppCategories.forEach { (key, val) in
                    if key != selectedCategory {
                        self.searchFilter?.selectedAppCategories[key] = false
                    }
                }
            }
            self.searchFilter?.selectedAppCategories[.All] = false
            tableView.reloadData()
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? FilterCategoryTableViewCell else { return UITableViewCell() }
        
        let categoryForRow = SearchResultsFilter.AppCategory.allCases[indexPath.row]
        cell.categoryTitleLabel.text = categoryForRow.rawValue
        
        if searchFilter?.selectedAppCategories[.All] == true {
            if categoryForRow == .All {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            if self.searchFilter?.selectedAppCategories[categoryForRow] == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchResultsFilter.AppCategory.allCases.count
    }
}
