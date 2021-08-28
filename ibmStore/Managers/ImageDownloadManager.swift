//
//  ImageDownloadManager.swift
//  ibmStore
//
//  Created by Amber Spadafora on 8/25/21.
//

import UIKit

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    private init(){}
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    func loadImageFromURLString(urlString: String, callback: @escaping (UIImage?, Data?)-> ()) {
        guard let validURL = URL(string: urlString) else {
            print("unable to create URL from \(urlString)")
            return
        }
        
        if let imagedata = imageCache.object(forKey: urlString as AnyObject) as? Data
            {
            callback(UIImage(data: imagedata), imagedata)
        } else {
            URLSession.shared.dataTask(with: validURL) { (data, response, error) in
                guard let validData = data else {
                    callback(nil, nil)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageCache.setObject(validData as AnyObject, forKey: urlString as AnyObject)
                    callback(UIImage(data: validData), validData)
                }
            }.resume()
        }
        
    }
}
