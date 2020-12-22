//
//  FontModel.swift
//  ScrapBook
//
//  Created by Solution Cat Sadik on 28/1/20.
//  Copyright © 2020 Solution Cat Sadik. All rights reserved.
//

import UIKit

class FontModel: NSObject {
    var fontName : String = ""
    var isPremium : Bool
    
    init(fontName : String , isPremium : Bool = false) {
        self.fontName = fontName
        self.isPremium = isPremium
    }
}
