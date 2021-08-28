//
//  SearchResultTableViewCell.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/24/21.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appCategoryLabel: UILabel!
    @IBOutlet weak var stackviewForVerticalScreenShots: UIStackView!
    @IBOutlet weak var stackViewForHorizontalScreenShots: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    
    // vertical screen shot image views
    @IBOutlet weak var firstScreenShotImgView: UIImageView!
    @IBOutlet weak var secondScreenShotImgView: UIImageView!
    @IBOutlet weak var thirdScreenShotImgView: UIImageView!
    @IBOutlet weak var fourthScreenShotImgView: UIImageView!
    
    // horizontal screen shot image views
    @IBOutlet weak var hFirstScreenShotImgView: UIImageView!
    @IBOutlet weak var hSecScreenShotImgView: UIImageView!
    @IBOutlet weak var hThirdScreenShotImgView: UIImageView!
    @IBOutlet weak var hFourthScreenShotImgView: UIImageView!
    
    var app: App? {
        didSet {
            guard let app = app else { return }
            let rating: Int = Int(app.averageUserRating.rounded())
            
            ratingView.setRating(rating: rating)
            appTitleLabel.text = app.appTitle
            appCategoryLabel.text = app.category
            
            if let price = app.formattedPrice {
                priceLabel.text = price
            }
            
            guard let preLoadedAppIcon = SearchResultswithImagesManager.shared.getAppIconFor(appId: app.trackId) else {
                print("unable to unwrap app icon from SearchResultswithImageManager")
                appIconImageView.loadImageFromURLString(urlString: app.appIcon100)
                return
            }
            appIconImageView.image = UIImage(data: preLoadedAppIcon)
            // update screenshot imageviews
            let screenshotUrlStringsForApp = app.screenshotUrls
            setScreenShotImageViews(screenshotUrlStringsForApp: screenshotUrlStringsForApp)

        }
    }
    
    
    func setScreenShotImageViews(screenshotUrlStringsForApp: [String]) {
        
        if screenshotUrlStringsForApp.count >= 4 {
            guard let screenshot1data = SearchResultswithImagesManager.shared.getScreenShotFor(screenshotUrl: screenshotUrlStringsForApp[0]),
                  let screenshot2data = SearchResultswithImagesManager.shared.getScreenShotFor(screenshotUrl: screenshotUrlStringsForApp[1]),
                  let screenshot3data = SearchResultswithImagesManager.shared.getScreenShotFor(screenshotUrl: screenshotUrlStringsForApp[2]),
                  let screenshot4data = SearchResultswithImagesManager.shared.getScreenShotFor(screenshotUrl: screenshotUrlStringsForApp[3]) else {
                return
            }
            
            guard let firstScreenShot = UIImage(data: screenshot1data) else { return }
            
            // checks orientation of first screen shot to determine which imageviews to display
            if firstScreenShot.size.width > firstScreenShot.size.height {
                self.stackviewForVerticalScreenShots.isHidden = true
                self.stackViewForHorizontalScreenShots.isHidden = false
                self.hFirstScreenShotImgView.image = UIImage(data: screenshot1data)
                self.hSecScreenShotImgView.image = UIImage(data: screenshot2data)
                self.hThirdScreenShotImgView.image = UIImage(data: screenshot3data)
                self.hFourthScreenShotImgView.image = UIImage(data: screenshot4data)
            } else {
                self.stackviewForVerticalScreenShots.isHidden = false
                self.stackViewForHorizontalScreenShots.isHidden = true
                self.firstScreenShotImgView.image = UIImage(data: screenshot1data)
                self.secondScreenShotImgView.image = UIImage(data: screenshot2data)
                self.thirdScreenShotImgView.image = UIImage(data: screenshot3data)
                self.fourthScreenShotImgView.image = UIImage(data: screenshot4data)
            }
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.appIconImageView.addCornerRadius(radius: 15)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


