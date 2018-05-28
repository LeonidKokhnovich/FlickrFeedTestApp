//
//  FeedViewModel.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import UIKit

protocol FeedViewModelDelegate: class {
    func didReceive(error: Error)
    func didUpdateItems()
}

class FeedItemViewModel {
    struct Config {
        static let placeholderImageIdentifier = ImageIdentifier.local(name: "ImagePlaceholder")
    }
    
    fileprivate let model: FeedItemModel
    fileprivate var image: UIImage?
    fileprivate var placeholderImage: UIImage?
    let author: String
    let title: String
    
    var showImageLoadingActivityIndicator: Bool {
        return image == nil ? true : false
    }
    
    var mediaImage: UIImage? {
        return image != nil ? image : placeholderImage
    }
    
    fileprivate init(model: FeedItemModel) {
        self.model = model
        
        author = model.author
        title = model.title
    }
}

protocol FeedViewModelType {
    var items: [FeedItemViewModel] { get }
    var delegate: FeedViewModelDelegate? { get set }
    
    func update()
}

class FeedViewModel: FeedViewModelType {
    // Dependencies
    private let provider: FeedProviderType
    private let imageProvider: ImageProviderType
    
    weak var delegate: FeedViewModelDelegate? = nil
    var items = [FeedItemViewModel]()
    
    init(provider: FeedProviderType = FeedProvider.shared,
         imageProvider: ImageProviderType = ImageProvider.shared) {
        self.provider = provider
        self.imageProvider = imageProvider
    }
    
    func update() {
        print("Update items")
        provider.fetchItems { [weak self] (result) in
            print("Did update items")
            switch result {
            case .success(let itemModels):
                let itemViewModels = itemModels.map { FeedItemViewModel(model: $0) }
                itemViewModels.forEach({ (itemViewModel) in
                    self?.loadImage(for: itemViewModel)
                })
                DispatchQueue.main.async {
                    self?.items = itemViewModels
                    self?.delegate?.didUpdateItems()
                }
            case .error(let error):
                DispatchQueue.main.async {
                    self?.delegate?.didReceive(error: error)
                }
            }
        }
    }
}

private extension FeedViewModel {
    func loadImage(for itemViewModel: FeedItemViewModel) {
        imageProvider.loadImage(with: FeedItemViewModel.Config.placeholderImageIdentifier, completionBlock: { [weak itemViewModel, delegate = self.delegate] (image) in
            itemViewModel?.placeholderImage = image
            
            DispatchQueue.main.async(execute: {
                delegate?.didUpdateItems()
            })
        })
        
        guard let imageURL = URL(string: itemViewModel.model.media.link) else {
            print("Invalid image URL: \(itemViewModel.model.media.link)")
            return
        }
        
        imageProvider.loadImage(with: .remote(url: imageURL)) { [weak itemViewModel, delegate = self.delegate] (image) in
            itemViewModel?.image = image
            
            DispatchQueue.main.async(execute: {
                delegate?.didUpdateItems()
            })
        }
    }
}
