//
//  FeedResponseModel.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

struct FeedItemMediaModel: Codable {
    enum CodingKeys: String, CodingKey {
        case link = "m"
    }
    
    let link: String
}

struct FeedItemModel: Codable {
    let title: String
    let link: String
    let media: FeedItemMediaModel
    let dateTaken: String
    let published: Date
    let author: String
    let authorId: String
    let tags: String
    let description: String
}

struct FeedResponseModel: Codable {
    let title: String
    let modified: Date
    let items: [FeedItemModel]
}
