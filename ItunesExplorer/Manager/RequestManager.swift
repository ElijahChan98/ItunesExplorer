//
//  RequestManager.swift
//  ItunesExplorer
//
//  Created by Elijah Tristan Huey Chan on 11/29/20.
//  Copyright © 2020 Elijah Tristan Huey Chan. All rights reserved.
//

import UIKit

public enum RequestMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

struct Constants {
    static let ITUNES_BASE_URL = "https://itunes.apple.com/search"
    static let GITHUB_USERS = "/users"
}


class RequestManager {
    static let shared = RequestManager()
    
    public func fetchItunesList(completion: @escaping (_ success: Bool, _ response: [String:Any]?) -> ()) {
        let queryItems = [URLQueryItem(name: "term", value: "star"),
                          URLQueryItem(name: "country", value: "au"),
                          URLQueryItem(name: "media", value: "movie"),
                          URLQueryItem(name: "all", value: nil),
        ]
        var urlComponents = URLComponents(string: Constants.ITUNES_BASE_URL)!
        urlComponents.queryItems = queryItems
        self.createGenericRequest(url: urlComponents.url!, requestMethod: .get) { (success, response) in
            completion(success, response)
        }
    }
    
    /// Generic Request Handler. Will return a success boolean and a response which can change values depending on the payload returned by the API
    private func createGenericRequest(url: URL, requestMethod: RequestMethod, completion: @escaping (_ success: Bool, _ response: [String: Any]?) -> ()) {
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 401 {
                    }
                    else if httpResponse.statusCode == 500 {
                        //internal server error
                    }
                }
                
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let payload = json as? [String: Any] {
                            completion(true, payload)
                        }
                        else if let payloads = json as? [[String:Any]] {
                            //print(payloads)
                            completion(true, ["payloads" : payloads])
                        }
                    }
                    catch {
                        print("something went wrong")
                    }
                }
                else {
                    completion(false, nil)
                }
            }
        }
        task.resume()
    }

}
