//
//  Result.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case error(E)
}
