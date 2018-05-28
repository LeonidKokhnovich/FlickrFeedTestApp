//
//  FeedJSONDecoderBuilder.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

protocol FeedJSONDecoderBuilderType {
    func build() -> JSONDecoder
}

class FeedJSONDecoderBuilder: FeedJSONDecoderBuilderType {
    static let shared = FeedJSONDecoderBuilder()
    
    func build() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
