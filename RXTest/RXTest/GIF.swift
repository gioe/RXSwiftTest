//
//  GIF.swift
//  RXTest
//
//  Created by Matt Gioe on 8/30/16.
//  Copyright © 2016 Matt Gioe. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GIF  {
    var url:String
    var slug : String
    var height:CGFloat
    var width:CGFloat
    var images : [String : JSON]
    
    init(json: JSON) {
        self.slug = json["slug"].stringValue
        self.images = json["images"]["downsized"].dictionaryValue
        self.url = self.images["url"]!.stringValue
        self.height = CGFloat((self.images["height"]!.stringValue as NSString).floatValue)
        self.width = CGFloat((self.images["width"]!.stringValue as NSString).floatValue)
    }
}
