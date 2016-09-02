//
//  GIFTableViewCell.swift
//  RXTest
//
//  Created by Matt Gioe on 8/31/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Gifu

class GIFCollectionViewCell : UICollectionViewCell {
    var cellGIF = GIF?()
    
    @IBOutlet weak var gifImage: AnimatableImageView!
    func setupCellWithGIF(gif : GIF){
        cellGIF = gif
//        frame = CGRectMake(frame.origin.x, frame.origin.y, gif.width, gif.height)
        let url = NSURL(string: gif.url)
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        gifImage.animateWithImageData(data!)
    }

}
