//
//  ItunesMedia.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/29/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

class ItunesMedia: Codable {
    enum CodingKeys: String, CodingKey {
        case trackName = "trackName"
        case artwork = "artworkUrl100"
        case price = "trackPrice"
        case genre = "primaryGenreName"
        case longDesc = "longDescription"
        
        case trackId = "trackId"
    }
    
    var trackName: String?
    var artwork: String?
    var price: Double?
    var genre: String?
    var longDesc: String?
    
    ///for data persistence use only
    var trackId: Int?
    var lastDateViewed: String?
    var viewCount: Int?
    
    var artworkImage = UIImage(named: "placeholder")
    
    ///Decoder func for ItunesMedia
    static func createItunesMediaFromPayload(_ payload: [String: Any]) -> ItunesMedia? {
        let decoder = JSONDecoder()
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            do {
                let user = try decoder.decode(ItunesMedia.self, from: jsonData)
                return user
            } catch {
                print(error.localizedDescription)
            }
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
