//
//  StringExtension.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/25/20.
//

import UIKit

extension String {
    
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension UITextView {
    func increaseFontSize () {
        var maxFontSize: CGFloat!
        if UIDevice.current.userInterfaceIdiom == .phone {
            maxFontSize = 32.0
        }else{
            maxFontSize = 50.0
        }
        self.font =  UIFont(name: self.font!.fontName, size: min( self.font!.pointSize + 1, CGFloat(maxFontSize)))
    }
}
