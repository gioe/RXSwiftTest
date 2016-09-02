//
//  GIFViewModel.swift
//  RXTest
//
//  Created by Matt Gioe on 8/31/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Alamofire

class GIFViewModel {
    
    private let httpService : GIFHTTPService
    private let disposeBag = DisposeBag()
    var searchGifs : Observable<[GIF]>
    var searchTextObservable = Variable<String>("")
    var gifArray :[GIF] = []

    init (httpService : GIFHTTPService){

        self.httpService = httpService
     
        searchGifs = searchTextObservable.asObservable()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest{ searchString -> Observable<[GIF]> in
                
                guard !searchString.isEmpty else {
                    return Observable.empty()
                }
                
                return httpService.search(forGif: searchString)
        }

    }
    
    func getGifs() -> Observable<[GIF]>{
        return Observable<[GIF]>.create { (observer) -> Disposable in
            
            let requestReference = Alamofire.request(.GET, "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC", parameters: nil, encoding: .JSON, headers: ["Content-type": "application/json"]).responseJSON { (responseObject) -> Void in
                
                if let value = responseObject.result.value!["data"] {
                    let valueArray = JSON(value!)
                    for gif in valueArray.arrayValue {
                        let currentGIF = GIF.init(json: gif)
                        self.gifArray.append(currentGIF)
                    }
                    observer.onNext(self.gifArray)
                    observer.onCompleted()
                }else if let error = responseObject.result.error {
                    observer.onError(error)
                    
                }
            }
            return AnonymousDisposable {
                requestReference.cancel()
            }
        }
    }
    
}