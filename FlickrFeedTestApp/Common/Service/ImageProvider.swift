//
//  ImageProvider.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

protocol ImageProviderType {
    
}

class ImageProvider: ImageProviderType {
    static let shared = ImageProvider()
}
