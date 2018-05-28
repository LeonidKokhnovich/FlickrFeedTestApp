//
//  FeedURLRequestBuilder.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

protocol FeedURLRequestBuilderType {
    func buildGetPublicPhotosRequest() -> URLRequest?
}

fileprivate enum HTTPEndpoints: String {
    case services
    case feeds
    case publicPhotos = "photos_public"
}

fileprivate enum HTTPHeaderFieldNames: String {
    case format
}

fileprivate enum ResponseFormat: String {
    case json
}

class FeedURLRequestBuilder: FeedURLRequestBuilderType  {
    struct Config {
        static let baseLink = "https://api.flickr.com"
    }
    
    func buildGetPublicPhotosRequest() -> URLRequest? {
        guard var url = URL(string: Config.baseLink) else {
            print("Invalid base url: \(Config.baseLink)")
            return nil
        }
        
        url.appendPathComponent(HTTPEndpoints.services.rawValue)
        url.appendPathComponent(HTTPEndpoints.feeds.rawValue)
        url.appendPathComponent(HTTPEndpoints.publicPhotos.rawValue)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(ResponseFormat.json.rawValue, forHTTPHeaderField: HTTPHeaderFieldNames.format.rawValue)
        
        return request
    }
}
