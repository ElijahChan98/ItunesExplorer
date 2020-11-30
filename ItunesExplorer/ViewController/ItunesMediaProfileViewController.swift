//
//  ItunesMediaProfileViewController.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/30/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class ItunesMediaProfileViewController: UIViewController, ItunesMediaProfileDelegate {
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var longDescTextView: UITextView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    var viewModel: ItunesMediaProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add rounded corners to get button
        getButton.layer.borderColor = UIColor.blue.cgColor
        getButton.layer.borderWidth = 0.8
        getButton.layer.cornerRadius = 15
        getButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        viewModel.viewLoaded()
    }
    
    ///This function should be called when the viewModel's data is ready to be displayed.
    func reloadUIElements() {
        let itunesMedia = viewModel.itunesMedia
        trackLabel.text = itunesMedia?.trackName
        genreLabel.text = itunesMedia?.genre
        longDescTextView.text = itunesMedia?.longDesc
        avatarImageView.image = itunesMedia?.artworkImage
        
        if let price = itunesMedia?.price, price != 0.0 {
            getButton.setTitle("$ \(price)", for: .normal)
        }
        
        if let viewCount = itunesMedia?.viewCount, viewCount != 0, let lastDateViewed = itunesMedia?.lastDateViewed {
            self.title = "Last Viewed: \(lastDateViewed)"
            self.viewCountLabel.text = "Media viewed \(viewCount) times"
        }
    }

    @IBAction func onGetButtonClicked(_ sender: Any) {
        //Do nothing for now. No purchase implementataion
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
