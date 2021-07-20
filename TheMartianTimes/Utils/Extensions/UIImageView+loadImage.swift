//
//  UIImage+LoadImage.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/11/21.
//  Copyright © 2021 Chanick Park. All rights reserved.
//

import UIKit


public extension UIImageView {
    func loadImage(fromURL url: String, _ completion: ((_ img: UIImage?, _ animation: Bool) -> Void)?) -> URLSessionDataTask? {
        guard let imageURL = URL(string: url) else {
            return nil
        }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        var task: URLSessionDataTask?
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data,
               let image = UIImage(data: data) {
                
                completion?(image, false)
            } else {
                task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data,
                       let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300,
                       let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        
                        completion?(image, true)
                    }
                })
                task?.resume()
            }
        }
        return task
    }
    
    func transition(toImage image: UIImage?, _ animation: Bool = true, _ completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            if animation == true {
                UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) {
                    self.image = image
                } completion: { result in
                    completion?(result)
                }
            } else {
                self.image = image
                completion?(true)
            }
            
        }
    }
}

