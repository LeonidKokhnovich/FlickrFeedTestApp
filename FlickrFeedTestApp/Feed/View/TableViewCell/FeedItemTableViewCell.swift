//
//  FeedItemTableViewCell.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell, Reusable {
    static let estimatedRowHeight = CGFloat(358)
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var loadingImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
}

extension FeedItemTableViewCell {
    func setup(with viewModel: FeedItemViewModel) {
        if viewModel.showImageLoadingActivityIndicator {
            loadingImageActivityIndicator.startAnimating()
        } else {
            loadingImageActivityIndicator.stopAnimating()
        }
        
        mediaImageView.image = viewModel.mediaImage
        titleLabel.text = viewModel.title
        authorLabel.text = viewModel.author
    }
}
