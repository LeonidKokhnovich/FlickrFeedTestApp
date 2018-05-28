//
//  LocalizedString.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import Foundation

enum LocalizedStringProvider {
    static let ok = NSLocalizedString("OK", comment: "OK")
    static let errorTitle = NSLocalizedString("Error", comment: "Error title")
    
    static func errorMessage(_ error: Error) -> String {
        return NSLocalizedString("There was an error: \(error.localizedDescription). Please, try again.", comment: "Error message")
    }
}
