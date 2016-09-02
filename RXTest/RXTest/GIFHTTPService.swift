//
//  GIFHTTPService.swift
//  RXTest
//
//  Created by Matt Gioe on 9/1/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class GIFHTTPService {
    
    private struct Constants {
        static let APIKey = "dc6zaTOxFJmzC"
        static let baseURL = "http://api.giphy.com/v1/gifs"
    }
    
    enum ResourcePath {
        case TrendingGifs
        case SearchGifs(searchString : String)
        
        var path: String {
            switch self {
            case .TrendingGifs:
                return "\(Constants.baseURL)/trending?api_key=\(Constants.APIKey)"
            case .SearchGifs(let search):
                return "\(Constants.baseURL)/search?q=\(search)&api_key=\(Constants.APIKey)"
            }
        }
    }

    
    func search(forGif gif: String)-> Observable<[GIF]> {
        let searchString = ResourcePath.SearchGifs(searchString: gif).path
        return request(.GET, searchString, parameters: nil, encoding: .URLEncodedInURL)
            .rx_JSON()
            .map(JSON.init)
            .flatMap { json -> Observable<[GIF]> in
                var gifArray : [GIF] = []
                for gif in json["data"].arrayValue
                {   print(gif)
                        let currentGIF = GIF.init(json: gif)
                        gifArray.append(currentGIF)
                    }

                return Observable.just(gifArray)
        }
    }
    
    
}