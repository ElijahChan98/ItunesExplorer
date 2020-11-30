//
//  ItunesListViewController.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/29/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

///The architecture used will be the MVVM architecture in order to reduce the amount of code contained inside the view controller
class ItunesListViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    var viewModel: ItunesListViewModel!
    let loader = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ItunesListViewModel()
        viewModel.delegate = self
        viewModel.fetchItunesList()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.register(UINib.init(nibName: "ItunesMediaCell", bundle: nil), forCellReuseIdentifier: "ItunesMediaCell")
    }

}

//MARK: - Tableview data souce and delegate

extension ItunesListViewController: UITableViewDelegate, UITableViewDataSource, ItunesListViewModelProtocol {
    
    func reloadTableView() {
        self.tableview.reloadData()
    }
    
    ///Cell should show an animating indicator while loading image. Use ImageLoader to load image asynchonously then show image. If image download does not finish before being unloaded, cancel download
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "ItunesMediaCell") as! ItunesMediaCell
        let itunesMedia = viewModel.itunesMedias[indexPath.row]
        
        cell.nameLabel.text = itunesMedia.trackName
        cell.genreLabel.text = itunesMedia.genre
        cell.priceLabel.text = "$\(itunesMedia.price ?? 0)"
        cell.activityIndicator.startAnimating()
        
        let imageUrl = URL(string: itunesMedia.artwork ?? "")
        
        let token = loader.loadImage(imageUrl!) { result in
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    itunesMedia.artworkImage = image
                    cell.avatarImageView.image = image
                    cell.activityIndicator.stopAnimating()
                }
            } catch {
                print(error)
            }
        }

        cell.onReuse = {
            if let token = token {
                self.loader.cancelLoad(token)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itunesMedias.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itunesMedia = viewModel.itunesMedias[indexPath.row]
        let vc = ItunesMediaProfileViewController()
        let viewModel = ItunesMediaProfileViewModel(media: itunesMedia, delegate: vc)
        vc.viewModel = viewModel
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
