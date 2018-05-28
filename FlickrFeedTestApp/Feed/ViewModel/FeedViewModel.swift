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
    private let image: UIImage?
    
    let author: String
    let title: String
    
    var showImageLoadingActivityIndicator: Bool {
        return image == nil ? true : false
    }
    
    var mediaImage: UIImage {
        if let image = image {
            return image
        } else {
            // TODO: Return placeholder
            return UIImage.init()
        }
    }
    
    fileprivate init(model: FeedItemModel) {
        author = model.author
        title = model.title
        // TODO: Provide image
        image = nil
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
    
    weak var delegate: FeedViewModelDelegate? = nil
    var items = [FeedItemViewModel]()
    
    init(provider: FeedProviderType = FeedProvider.shared) {
        self.provider = provider
    }
    
    func update() {
        print("Update items")
        
        provider.fetchItems { [weak self] (result) in
            print("Did update items with result: \(result)")
            
            switch result {
            case .success(let itemModels):
                let itemViewModels = itemModels.map { FeedItemViewModel(model: $0) }
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
