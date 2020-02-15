//
//  UIImageView+dowload.swift
//  GoogleUXTest
//
//  Created by Jagadeeshwar Reddy on 15/02/20.
//  Copyright © 2020 Tesco. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    
    /// Download or return cached image for urlString
    func loadImage(from urlSting: String, placeHolder: UIImage? = nil) {
        guard let url = URL(string: urlSting) else { return }
        image = placeHolder
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let imageData = data, let imageToCache = UIImage(data: imageData) {
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                DispatchQueue.main.async {
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}
