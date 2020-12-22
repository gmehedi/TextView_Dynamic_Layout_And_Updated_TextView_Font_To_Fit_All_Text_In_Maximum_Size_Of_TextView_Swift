//
//  FontLoader.swift
//  ScrapBook
//
//  Created by Solution Cat Sadik on 28/1/20.
//  Copyright © 2020 Solution Cat Sadik. All rights reserved.
//

import UIKit

class FontLoader: NSObject {
    static let shared = FontLoader()
    
    private override init(){}
    
    func resourceCheck() {
           
        let resourchPath : NSString = Bundle.main.resourcePath! as NSString
        let contents = try! FileManager.default.contentsOfDirectory(atPath: resourchPath as String)
       // print("path : \(resourchPath)")
        for i in contents{
            
            let path : NSString = resourchPath.appendingPathComponent(i) as NSString
            //print(path)
            if path.hasSuffix(".jpg") {
                print(path)
            }
        }
    
    }
    
    func loadFont() ->Array<FontModel> {
        var array = Array<FontModel>()
        var fontList = Array<String>()
     //   let isPremium = AppStore.shared.isPremium()
        let resourchPath : NSString = Bundle.main.resourcePath! as NSString
        let contents = try! FileManager.default.contentsOfDirectory(atPath: resourchPath as String)
        
        var x = 0
        
        for i in contents{
            
            let path : NSString = resourchPath.appendingPathComponent(i) as NSString
            //print(i)
            
            if path.hasSuffix(".ttf") || path.hasSuffix(".otf"){
                //print("<string>\(path.lastPathComponent)</string>")
                var name = path.lastPathComponent
                if name.hasSuffix(".ttf"){
                    name = name.replacingOccurrences(of: ".ttf", with: "")
                }else {
                    name = name.replacingOccurrences(of: ".otf", with: "")
                }
                //print("font name : \(name)")
                let fontName = name
                //let fontName = installFont(path as String)
                if fontName.count > 0{
                    let model = FontModel(fontName: fontName)
                    if x > 10 {
                       // model.isPremium = !isPremium
                    }
                    array.append(model)
                    x += 1
                    fontList.append(fontName)
                }
            }
            
            
        }
        
//        UserDefaults.standard.setValue(fontList, forKeyPath: "fontNames")
//        UserDefaults.standard.synchronize()
//
        array.sort { (f1, f2) -> Bool in
            return f1.fontName.lowercased() < f2.fontName.lowercased()
        }
       // print("first font : \(array.first?.fontName ?? "")")
        //array.insert(sys, at: 0)
        
        return array
    }
    
    private func installFont(_ fontUrl:String) -> String {

//        guard let fontUrl = Bundle.main.url(forResource: font, withExtension: "ttf") else {
//            return false
//        }

        let fontData = try! Data(contentsOf: URL(fileURLWithPath: fontUrl))

        if let provider = CGDataProvider.init(data: fontData as CFData) {

            var error: Unmanaged<CFError>?

            let font:CGFont = CGFont(provider)!
            
            if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
                print(error.debugDescription)
                return ""
            } else {
                return font.fullName! as String
            }
        }
        return ""
    }
}
