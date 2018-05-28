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
        static let targetEndpointExtension = "gne"
    }
    
    func buildGetPublicPhotosRequest() -> URLRequest? {
        guard var url = URL(string: Config.baseLink) else {
            print("Invalid base url: \(Config.baseLink)")
            return nil
        }
        
        url.appendPathComponent(HTTPEndpoints.services.rawValue)
        url.appendPathComponent(HTTPEndpoints.feeds.rawValue)
        url.appendPathComponent(HTTPEndpoints.publicPhotos.rawValue)
        url.appendPathExtension(Config.targetEndpointExtension)
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print("Unable to create URLComponents from: \(url)")
            return nil
        }
        
        urlComponents.queryItems = [URLQueryItem(name: HTTPHeaderFieldNames.format.rawValue,
                                                 value: ResponseFormat.json.rawValue)]
        
        guard let resolvedURL = urlComponents.url else {
            print("Unable to resolve URL from: \(urlComponents)")
            return nil
        }
        
        var request = URLRequest(url: resolvedURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
