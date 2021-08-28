//
//  SearchResultswithImagesManager.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/25/21.
//

import UIKit

protocol SearchResultswImagesDelegate {
    func imageDownloadComplete()
}

/**
 A singleton class that manages the downloading of a set limit of App images, which can be updating by calling updatingDownloadLimit(newLimit: Int). Each time a search is ran, the results and resultsWithImagesLoaded  are reset to empty arrays.
 
 Designed to be used as a datasource for a table or collectionview to aid in the issue of asynchronously downloading images in a reusable cell
 
 
 */
class SearchResultswithImagesManager {
    
    private init(){}
    static let shared = SearchResultswithImagesManager()
    
    var delegate: SearchResultswImagesDelegate?
    
    private var limit = 25
    
    private var indexOfLastLoadedResult = 0
    
    public func getIndexofLastLoadedResult() -> Int {
        return indexOfLastLoadedResult
    }
    
    var resultsWithImagesLoaded: [App] = []
    
    private var screenShotDictionary: [String: Data] = [:]
    
    public func getScreenShotFor(screenshotUrl urlString: String) -> Data? {
        return screenShotDictionary[urlString]
    }
    
    private var appIconDictionary: [Int64: Data] = [:]
    
    public func getAppIconFor(appId: Int64) -> Data? {
        return appIconDictionary[appId]
    }
    
    // when updated will trigger download of images for n(limit) results
    var results: [App] = [] {
        didSet {
            if results.count == 0 && filteredResults.count == 0 {
                delegate?.imageDownloadComplete()
                return
            }
            
            // resets array that will store results that are ready for display, and resets index of last loaded result
            if resultsWithImagesLoaded.count > 0 { resultsWithImagesLoaded.removeAll() }
            indexOfLastLoadedResult = 0
            if screenShotDictionary.count > 0 { screenShotDictionary.removeAll() }
            
            if appIconDictionary.count > 0 { appIconDictionary.removeAll() }
            if filteredResults.count > 0 { filteredResults.removeAll() }
            
            loadResultImages(results: results)
        }
    }
    
    var filteredResults: [App] = [] {
        didSet {
            if resultsWithImagesLoaded.count > 0 { resultsWithImagesLoaded.removeAll() }
            indexOfLastLoadedResult = 0
            if screenShotDictionary.count > 0 { screenShotDictionary.removeAll() }
            
            if appIconDictionary.count > 0 { appIconDictionary.removeAll() }
            
            if filteredResults.count == 0 && results.count == 0 {
                delegate?.imageDownloadComplete()
                return
            } else if filteredResults.count == 0 && results.count != 0 {
                return
            }
            
            loadResultImages(results: filteredResults)
        }
    }
    
    func prepareForNewSearch() {
        self.results = []
        self.resultsWithImagesLoaded = []
        self.indexOfLastLoadedResult = 0
        
    }
    
    func loadResultImages(results: [App]) {
        
        let dispatchgroup = DispatchGroup()
        if indexOfLastLoadedResult >= results.count {
            delegate?.imageDownloadComplete()
        }
        // loads only n(limit) amount of result screenshot images
        limit = min(25, results.count)

        var endOfRange = results.count
        if indexOfLastLoadedResult + limit < results.count {
            endOfRange = indexOfLastLoadedResult + limit
        } else {
            endOfRange = results.count
        }
        
        // loop over each result to download their screenshots & app icons
        for i in indexOfLastLoadedResult..<endOfRange {
            
            let appIconUrlString = results[i].appIcon100
            dispatchgroup.enter()
            
            ImageDownloadManager.shared.loadImageFromURLString(urlString: appIconUrlString) { (_, data) in
                guard let validData = data else { return }
                self.appIconDictionary[results[i].trackId] = validData
                dispatchgroup.leave()
            }
            for screenshotUrlString in results[i].screenshotUrls {
                dispatchgroup.enter()
                ImageDownloadManager.shared.loadImageFromURLString(urlString: screenshotUrlString) { (_, data) in
                    guard let data = data else {
                        dispatchgroup.leave()
                        return
                    }
                    self.screenShotDictionary[screenshotUrlString] = data
                    dispatchgroup.leave()
                }
            }
            
            resultsWithImagesLoaded.append(results[i])
            
            indexOfLastLoadedResult += 1
        }
        dispatchgroup.notify(queue: .main) {
            self.delegate?.imageDownloadComplete()
        }
    }
    
    
}
