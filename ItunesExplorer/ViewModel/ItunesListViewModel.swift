//
//  ItunesListViewModel.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/29/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class ItunesListViewModel {
    var delegate: ItunesListViewModelProtocol?
    var itunesMedias: [ItunesMedia] = []
    
    ///will fetch itunes list using RequestManager, then notify the view to reload itself when finished
    func fetchItunesList() {
        RequestManager.shared.fetchItunesList { (success, response) in
            if success, let results = response?["results"] as? [[String: Any]] {
                for result in results {
                    if let media = ItunesMedia.createItunesMediaFromPayload(result) {
                        self.itunesMedias.append(media)
                    }
                }
                self.delegate?.reloadTableView()
            }
        }
    }
}

@objc protocol ItunesListViewModelProtocol {
    func reloadTableView()
}
