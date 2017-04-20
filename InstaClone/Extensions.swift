//
//  Extensions.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 20/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit

let imageCached = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func circlerImage(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        //check cache for image first
        if let cachedImaged = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImaged
            return
        }
        
        //otherwise fire off a new download
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
