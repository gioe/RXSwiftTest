 //
//  ViewController.swift
//  RXTest
//
//  Created by Matt Gioe on 8/30/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation
import SwiftyJSON

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gifCollectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var collectionViewData: [GIF]? {
        didSet {
            gifCollectionView.reloadData()
        }
    }
    
    var tableViewData: [GIF]? {
        didSet {
            searchDisplayController?.searchResultsTableView.reloadData()
        }
    }

    private var viewModel: GIFViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifCollectionView.rx_setDelegate(self)
        viewModel = GIFViewModel.init(httpService: GIFHTTPService())
        registerNibs()
        setupBindings(viewModel)
    }
    
    func registerNibs(){
        let collectionViewNibName = UINib(nibName: "GIFCollectionViewCell", bundle:nil)
        let tableViewNibName = UINib(nibName: "GIFTableViewCell", bundle:nil)

        gifCollectionView.registerNib(collectionViewNibName, forCellWithReuseIdentifier: "CollectionCell")
        searchDisplayController?.searchResultsTableView.registerNib(tableViewNibName, forCellReuseIdentifier: "TableCell")

    }
    
    func setupBindings(viewModel: GIFViewModel){
        
        viewModel.getGifs()
            .bindTo(gifCollectionView.rx_itemsWithDataSource(self))
            .addDisposableTo(disposeBag)
        
        viewModel.searchGifs
            .bindTo((searchDisplayController?.searchResultsTableView.rx_itemsWithDataSource(self))!)
            .addDisposableTo(disposeBag)
        
        searchBar.rx_text
            .bindTo(viewModel.searchTextObservable)
            .addDisposableTo(disposeBag)

    }
    
}

extension ViewController : UICollectionViewDataSource, RxCollectionViewDataSourceType, UICollectionViewDelegate {
        
    func collectionView(collectionView: UICollectionView, observedEvent: Event<[GIF]>) -> Void {
        
        switch observedEvent {
        case .Next( _):
            collectionViewData = observedEvent.element!
        case .Error( _): break
        case .Completed:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! GIFCollectionViewCell
        
        guard (collectionViewData?[indexPath.row]) != nil else {
            return cell
        }
        cell.setupCellWithGIF(collectionViewData![indexPath.row])
        return cell

    }
    
}

//extension ViewController : UICollectionViewDelegateFlowLayout{
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        if (collectionViewData?.isEmpty)! || collectionView.accessibilityElementCount() == 0{
//            return CGSizeMake(0,0)
//        } else {
//            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GIFCollectionViewCell
//            return CGSizeMake(cell.cellGIF!.width, cell.cellGIF!.height)
//        }
//    
//    }
//}


extension ViewController: UITableViewDataSource, RxTableViewDataSourceType {
    
    //Gets called on tableView.rx_elements.bindTo methods
    func tableView(tableView: UITableView, observedEvent: Event<[GIF]>) {
        
        switch observedEvent {
            case .Next( _):
                tableViewData = observedEvent.element!
            case .Error( _): break
            case .Completed:
                tableViewData = observedEvent.element!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! GIFTableViewCell
        
        guard let gif = tableViewData?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = gif.url

        return cell
    }
}