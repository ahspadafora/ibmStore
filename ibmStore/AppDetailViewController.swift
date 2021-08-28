//
//  AppDetailViewController.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/27/21.
//

import UIKit

class AppDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    @IBOutlet weak var appSizeLabel: UILabel!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appPriceLabel: UILabel!
    @IBOutlet weak var appCategoryLabel: UILabel!
    
    @IBOutlet weak var appIconImageView: UIImageView!
    
    @IBOutlet weak var appDetailLabel: UILabel!
    let byteFormatter = ByteCountFormatter()
    
    var appToDisplay: App? {
        didSet {
            DispatchQueue.main.async {
                self.appTitleLabel.text = self.appToDisplay?.appTitle
                self.appPriceLabel.text = self.appToDisplay?.formattedPrice ?? "Free"
                self.appCategoryLabel.text = self.appToDisplay?.category
                
                self.appIconImageView.loadImageFromURLString(urlString: self.appToDisplay?.appIcon100 ?? "")
                self.appIconImageView.addCornerRadius(radius: 15)
                self.appDetailLabel.text = self.appToDisplay?.description ?? ""
                
                let byteSize = Int64(self.appToDisplay?.size ?? "0")
                let byteString = self.byteFormatter.string(fromByteCount: byteSize ?? 0)
                self.appSizeLabel.text = byteString
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appToDisplay?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenShotCell", for: indexPath) as? ScreenShotCollectionViewCell else { return UICollectionViewCell() }
        
        cell.screenshotImageView.loadImageFromURLString(urlString: self.appToDisplay?.screenshotUrls[indexPath.row] ?? "")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 3
        let height = collectionView.frame.height * 0.95
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
