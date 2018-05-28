//
//  ImageProvider.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import UIKit

enum ImageIdentifier: CustomStringConvertible {
    case local(name: String)
    case remote(url: URL)
    
    var description: String {
        switch self {
        case .local(let name):
            return name
        case .remote(let url):
            return url.description
        }
    }
}

protocol ImageProviderType {
    func loadImage(with identifier: ImageIdentifier, completionBlock: @escaping (_ image: UIImage?) -> Void)
}

class ImageProvider: ImageProviderType {
    static let shared = ImageProvider()
    
    // Dependencies
    private let session: URLSession
    
    let cache = NSCache<NSString, UIImage>()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(with identifier: ImageIdentifier, completionBlock: @escaping (_ image: UIImage?) -> Void) {
        if let image = cache.object(forKey: identifier.description as NSString) {
            completionBlock(image)
            return
        }
        
        switch identifier {
        case .local(let name):
            if let image = UIImage(named: name) {
                cache.setObject(image, forKey: identifier.description as NSString)
                completionBlock(image)
            } else {
                completionBlock(nil)
            }
        case .remote(let url):
            let task = session.dataTask(with: url) { [cache = self.cache] (data, response, error) in
                guard error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == HTTPResponseStatusCode.success.rawValue,
                    let data = data,
                    let image = UIImage(data: data) else {
                        completionBlock(nil)
                        return
                }
                
                cache.setObject(image, forKey: identifier.description as NSString)
                completionBlock(image)
            }
            task.resume()
        }
    }
}
