//
//  FeedProviderHelperType.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

protocol FeedProviderHelperType {
    func extractJSONData(from responseData: Data) -> Data?
}

class FeedProviderHelper: FeedProviderHelperType {
    struct ResponseWrapper {
        static let prefix = "jsonFlickrFeed("
        static let postfix = ")"
    }
    
    func extractJSONData(from responseData: Data) -> Data? {
        guard responseData.count > ResponseWrapper.prefix.count + ResponseWrapper.postfix.count else {
            print("Response data is not long enough: \(responseData.count)")
            return nil
        }
        
        let jsonRange = Range(ResponseWrapper.prefix.count...responseData.count - ResponseWrapper.postfix.count - 1)
        return responseData.subdata(in: jsonRange)
    }
}
