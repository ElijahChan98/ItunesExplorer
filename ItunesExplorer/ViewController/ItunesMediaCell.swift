//
//  ItunesMediaCell.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/29/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class ItunesMediaCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onReuse: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    ///This is called when cell is about to be reused and removed from view
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        avatarImageView.image = nil
    }
    
}
