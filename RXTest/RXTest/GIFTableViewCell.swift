//
//  GIFTableViewCell.swift
//  RXTest
//
//  Created by Matt Gioe on 9/1/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//

import UIKit

class GIFTableViewCell : UITableViewCell {

    @IBOutlet weak var urlLabel: UILabel!

    func setupCellWithGIF(gif : GIF){
       urlLabel.text = gif.url
    }
}