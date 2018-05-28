//
//  FeedManager.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

enum FeedProviderError: Error {
    case invalidURLRequest
    case invalidResponse
    case invalidResponseData
    case failedToParseResponse
    case requestFailed(statusCode: Int)
    case internalError(Error)
}

protocol FeedProviderType {
    func fetchItems(with completionBlock: @escaping (_ result: Result<[FeedItemModel], FeedProviderError>) -> Void)
}

class FeedProvider: FeedProviderType {
    static let shared = FeedProvider()
    
    // Dependencies
    private let session: URLSession
    private let decoder: JSONDecoder
    private let requestBuilder: FeedURLRequestBuilderType
    private let helper: FeedProviderHelperType
    
    init(session: URLSession = .shared,
         decoder: JSONDecoder = FeedJSONDecoderBuilder.shared.build(),
         requestBuilder: FeedURLRequestBuilderType = FeedURLRequestBuilder(),
         helper: FeedProviderHelperType = FeedProviderHelper()) {
        self.session = session
        self.decoder = decoder
        self.requestBuilder = requestBuilder
        self.helper = helper
    }
    
    func fetchItems(with completionBlock: @escaping (_ result: Result<[FeedItemModel], FeedProviderError>) -> Void) {
        guard let urlRequest = requestBuilder.buildGetPublicPhotosRequest() else {
            completionBlock(.error(.invalidURLRequest))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { [decoder = self.decoder, helper = self.helper] (data, response, error) in
            if let error = error {
                completionBlock(.error(.internalError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionBlock(.error(.invalidResponse))
                return
            }
            
            guard response.statusCode == HTTPResponseStatusCode.success.rawValue else {
                completionBlock(.error(.requestFailed(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data,
                let jsonData = helper.extractJSONData(from: data) else {
                completionBlock(.error(.invalidResponseData))
                return
            }
            
            guard let responseModel = try? decoder.decode(FeedResponseModel.self, from: jsonData) else {
                completionBlock(.error(.failedToParseResponse))
                return
            }
            
            completionBlock(.success(responseModel.items))
        }
        task.resume()
    }
}
