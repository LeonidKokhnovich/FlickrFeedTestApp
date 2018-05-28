//
//  FeedItemTableViewCell.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var loadingImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
}
