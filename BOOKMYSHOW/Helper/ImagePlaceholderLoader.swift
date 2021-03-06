//
//  ImagePlaceholderLoader.swift
//  maxgetmore
//
//  Created by Sanjay Mali on 26/04/18.
//  Copyright © 2018 loylty. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
class ImagePlaceholderLoader: UIImageView {
        var imageURL: URL?
        let activityIndicator = UIActivityIndicatorView()
        func loadImageWithUrl(_ url: URL) {
            activityIndicator.color = .orange
            addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            imageURL = url
            image = nil
            activityIndicator.startAnimating()
            // retrieves image if already available in cache
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.image = imageFromCache
                activityIndicator.stopAnimating()
                return
            }
            // image does not available in cache.. so retrieving it from url...
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                DispatchQueue.main.async(execute: {
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        if self.imageURL == url {
                            self.image = imageToCache
                        }
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    }
                    DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    }
                })
            }).resume()
        }
}
