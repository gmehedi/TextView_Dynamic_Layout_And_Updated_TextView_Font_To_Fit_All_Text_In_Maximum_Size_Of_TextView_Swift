//
//  TextViewInfExtension.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 12/13/20.
//

import UIKit

struct TextViewInformation {
    var text: String!
    var width: CGFloat!
    var height: CGFloat!
    var font: UIFont!
    var alignment: NSTextAlignment!
    var shadow: CGFloat!
    var background: UIColor!
    var textColor: UIColor!
    var bGColor: UIColor!
    
    init(text: String, width: CGFloat, height: CGFloat, font: UIFont, alignment: NSTextAlignment, shadow: CGFloat, background: UIColor, textColor: UIColor, bGColor: UIColor) {
        self.text = text
        self.width = width
        self.height = height
        self.font = font
        self.alignment = alignment
        self.shadow = shadow
        self.background = background
        self.textColor = textColor
        self.bGColor = bGColor
    }
    
}
