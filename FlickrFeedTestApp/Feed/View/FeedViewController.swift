//
//  FeedViewController.swift
//  FlickrFeedTestApp
//
//  Created by Leonid Kokhnovych on 2018-05-27.
//  Copyright © 2018 LeonidKokhnovych. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    // Dependencies
    var viewModel: FeedViewModelType = FeedViewModel()

    @IBOutlet weak var itemsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.registerReusableCell(FeedItemTableViewCell.self)
        viewModel.delegate = self
        viewModel.update()
    }

    @IBAction func onRefreshButtonTapped(_ sender: Any) {
        viewModel.update()
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func didReceive(error: Error) {
        let alertVC = UIAlertController(title: LocalizedStringProvider.errorTitle,
                                        message: LocalizedStringProvider.errorMessage(error),
                                        preferredStyle: .alert)
        present(alertVC, animated: true, completion: nil)
    }
    
    func didUpdateItems() {
        itemsTableView.reloadData()
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FeedItemTableViewCell.self)
        return cell
    }
}
