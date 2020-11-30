//
//  ItunesMediaProfileViewModel.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/30/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class ItunesMediaProfileViewModel {
    var itunesMedia: ItunesMedia!
    var delegate: ItunesMediaProfileDelegate?
    
    init(media: ItunesMedia, delegate: ItunesMediaProfileDelegate) {
        self.itunesMedia = media
        self.delegate = delegate
    }
    
    func viewLoaded() {
        fetchMediaRecord()
    }
    
    ///function will save a record of the viewing details for that particular media
    func saveMediaRecord() {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd hh:mm a"
        let dateString = dateFormatter.string(from: date)
        
        self.itunesMedia.lastDateViewed = dateString
        if itunesMedia.viewCount != nil {
            itunesMedia.viewCount! += 1
        }
        else {
            itunesMedia.viewCount = 1
        }
        
        ItunesMediaPersistence.shared.save(itunesMedia: itunesMedia)
    }
    
    ///Check if a view record exists for that certain media - then notify the view controller to display the view details
    func fetchMediaRecord() {
        ItunesMediaPersistence.shared.retrieveItunesMediaRecord(trackId: itunesMedia.trackId!) { (success, itunesMediaRecord) in
            if success == true, let mediaRecord = itunesMediaRecord {
                self.itunesMedia.lastDateViewed = mediaRecord.lastDateViewed
                self.itunesMedia.viewCount = mediaRecord.viewCount
                self.delegate?.reloadUIElements()
                self.saveMediaRecord()
            }
            else {
                self.delegate?.reloadUIElements()
                self.saveMediaRecord()
            }
        }
    }
}

protocol ItunesMediaProfileDelegate {
    func reloadUIElements()
}
