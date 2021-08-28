//
//  UIImageView+Ext.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/25/21.
//

import UIKit

extension UIImageView {
    func loadImageFromURLString(urlString: String) {
        guard let validUrl = URL(string: urlString) else {
            print("unable to create URL from \(urlString)")
            return
        }
        if let imageData = ImageDownloadManager.shared.imageCache.object(forKey: urlString as AnyObject) as? Data {
            let imgData = Data(imageData)
            self.image = UIImage(data: imgData)
        } else {
            URLSession.shared.dataTask(with: validUrl) { (data, response, error) in
                guard let validData = data else { return }
                DispatchQueue.main.async {
                    ImageDownloadManager.shared.imageCache.setObject(NSData(data: validData), forKey: NSString(string: urlString))
                    self.image = UIImage(data: validData)
                }
            }.resume()
        }
    }
}

extension UIImageView {
    func addCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

