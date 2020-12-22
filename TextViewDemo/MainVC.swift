//
//  MainVC.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 12/20/20.
//

import UIKit

class MainVC: UIViewController, TextViewVCDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @IBOutlet weak var topContainerView: UIView!
    var currentTextView: TextView!
    var currentContainerView: UIView!
    var initialBounds: CGRect!
    var currentFontSize: CGFloat!
    fileprivate var maxFontSize: CGFloat!
    //var initialDistance: CGFloat!
    var initialOrigin: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.maxFontSize = 32
        }else{
            self.maxFontSize = 50
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedOnAddText(_ sender: UIButton) {
        let textVC = TextViewVC(nibName: "TextViewVC", bundle: nil)
        textVC.modalPresentationStyle = .fullScreen
        textVC.isNewTextView = true
        textVC.delegate = self
        self.navigationController?.present(textVC, animated: true, completion: nil)
    }
    
    //MARK: Add Sticker and Update Sticker
    func addNewTextSticker(textView: TextView, isNewTextView: Bool) {
        //print("H1  ", textView.text)
        if isNewTextView {
            self.addText(mainTextView: textView)
        }else{
            
            self.currentTextView.text = prepareText(numOfLine: textView.numberOfLine(), font: textView.font!, text: textView.text, singleLinewidth: UIScreen.main.bounds.width - 10)
            let newSize = self.currentTextView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
           print("New Size  ", newSize)
            self.currentContainerView.bounds.size = CGSize(width: newSize.width, height: newSize.height)
          //  self.currentTextView.bounds.size = CGSize(width: newSize.width, height: newSize.height)
            
            
            
           // self.currentContainerView.frame.origin = self.currentTextView.frame.origin
        }
        
    }

}


extension MainVC {
    
    func addText(mainTextView: TextView){
      //  print("H2  ", mainTextView.text)
        if mainTextView.text == ""{
            return
        }
        let frame = mainTextView.frame
        let container = UIView(frame: frame)
        container.backgroundColor = UIColor.clear
        
        let textView = TextView(frame: mainTextView.bounds)
        let text = prepareText(numOfLine: mainTextView.numberOfLine(), font: mainTextView.font!, text: mainTextView.text, singleLinewidth: UIScreen.main.bounds.width - 10)
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textView.text = text
        textView.fontSize = mainTextView.font!.pointSize
       // print("CReat Sz ", textView.fontSize)
        textView.textColor = mainTextView.textColor
        textView.autocorrectionType = .no
        textView.backgroundColor = mainTextView.backgroundColor
        textView.isEditable = false
        textView.font = mainTextView.font
        textView.isSelectable = false
        textView.textAlignment = mainTextView.textAlignment
        textView.isScrollEnabled = false
        textView.font = mainTextView.font
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: newSize.width, height: newSize.height)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler))
        pinchGestureRecognizer.delegate = self
        container.addGestureRecognizer(pinchGestureRecognizer)
        
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged))
        container.addGestureRecognizer(moveGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece))
        rotationGesture.delegate = self
        container.addGestureRecognizer(rotationGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnSelectedTextView(_ :)))
        textView.addGestureRecognizer(tapGesture)
        
        self.currentTextView = textView
        container.addSubview(textView)
        self.currentContainerView = container
        
        DispatchQueue.main.async {
            self.topContainerView.addSubview(container)
        }
     //   print("Number Of Line  ", textView.numberOfLine())
    }
    
    func prepareText(numOfLine: Int, font: UIFont, text: String, singleLinewidth: CGFloat) -> String {
       // print("R1  ", text)
        let totalWidth = text.widthOfString(usingFont: font)
       // let singleLinewidth = totalWidth / CGFloat(numOfLine)
        var temp = ""
        var now = ""
        var lastIndex = -1
        var array = [String]()
        var i = 0
        
        while i < text.count {
            let t = text[i]
            now = temp + String(t)
            if t == " "{
                lastIndex = i
            }
            if lastIndex != -1 && now.widthOfString(usingFont: font) > singleLinewidth {
                while i > lastIndex && !temp.isEmpty {
                   // print("Re  ", temp)
                    temp.removeLast()
                    i -= 1
                }
               // print("After   :  ", temp)
                array.append(temp)
                lastIndex = -1
                temp = ""
                now = ""
            }else if now.widthOfString(usingFont: font) > singleLinewidth {
                array.append(temp)
                temp = ""
                now = ""
                lastIndex = -1
            }
            else {
                temp += String(t)
            }
            if t == "\n"{
                array.append(temp)
                temp = ""
                now = ""
            }
            i += 1
        }
        
        if now != "" {
            array.append(temp)
        }
        
        var result = ""
        for i in 0 ..< array.count {
            result += array[i]
            let last = array[i].last
         //   print("LL ", last)
            if i < array.count - 1 &&  last != "\n"{
                result += "\n"
            }
        }
//       // print("RR  ", result)
//        var final = ""
//
//        i = 0
//        while i < result.count {
//            final += result[i]
//            if result[i] == "\n"{
//                while(i + 1 < result.count && result[i + 1] == "\n"){
//                    i += 1
//                }
//            }
//
//        }
       // print("R2  ", result)
        return result
    }
    
    func getFrame(view: UIView) -> CGRect {
        return CGRect(x: view.bounds.width - 50, y: 0, width: 50, height: 50)
    }
    
//    @objc func  panHandler(recognizer : UIPanGestureRecognizer) {
//        print("Pann")
//        let touchLocation = recognizer.location(in: self.view)
//        switch  recognizer.state {
//        case .began:
//            self.initialBounds = self.currentTextView.bounds
//            self.initialDistance  = CGPointGetDistance(point1: self.view.center, point2: touchLocation)
//        case .changed:
//            let scale = CGPointGetDistance(point1: self.view.center, point2: touchLocation) / self.initialDistance
//            self.currentTextView.font = UIFont(name: self.currentTextView.font!.fontName, size: self.currentTextView.font!.pointSize * scale)
//            self.currentTextView.bounds = CGRectScale(self.initialBounds, wScale: scale, hScale: scale)
//        case .ended:
//            print("End")
//        case .cancelled:
//            print("Cancell")
//        default:
//            print("Not Match")
//        }
//    }
    
    @objc func pinchHandler(recognizer : UIPinchGestureRecognizer) {

       // print ("PINCHING NOW")
        switch recognizer.state {
        case .began:
            self.initialBounds = self.currentTextView.bounds
            self.initialOrigin = self.currentTextView.frame.origin
        case .changed:
            if let tview = recognizer.view as? UIView {
                var view: TextView!
                for sub in tview.subviews{
                    view = sub as! TextView
                }
                let scale = recognizer.scale
                view.font = UIFont(name: view.font!.fontName, size: view.font!.pointSize * scale)
                
                let newSize = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            //   print("New Size  ", newSize)
               view.bounds.size = CGSize(width: newSize.width, height: newSize.height)
                tview.bounds.size = CGSize(width: newSize.width, height: newSize.height)
                view.frame.origin = CGPoint(x: 0, y: 0)
                recognizer.scale = 1
            }
        case .ended:
            print("End")
        default:
            print("Not Match")
            
        }
       
    }
    
    @objc func wasDragged(_ gestureRecognizer: UIPanGestureRecognizer) {

        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {

            let translation = gestureRecognizer.translation(in: self.view)
           // print(gestureRecognizer.view!.center.y)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
           gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
    }
    
    @objc func rotatePiece(_ gestureRecognizer : UIRotationGestureRecognizer) {   // Move the anchor point of the view's layer to the center of the
       // user's two fingers. This creates a more natural looking rotation.
       guard gestureRecognizer.view != nil else { return }

       if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.rotated(by: gestureRecognizer.rotation)
          gestureRecognizer.rotation = 0
       }
    }
    
    @objc func tappedOnSelectedTextView(_ recognizer: UITapGestureRecognizer){
        print("Tapped")
        if let view = recognizer.view as? TextView {
            self.currentTextView = view
            self.currentContainerView = view.superview
            let editeItem = UIMenuItem(title: "Edit Text", action: #selector(editTextView))
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteTextView))
            
            let menu = UIMenuController.shared
            menu.menuItems = [editeItem, deleteItem]
            menu.showMenu(from: view, rect: view.bounds)
            view.becomeFirstResponder()
        }
        
    }
    
    @objc func editTextView(){
        
        let textVC = TextViewVC(nibName: "TextViewVC", bundle: nil)
        textVC.modalPresentationStyle = .fullScreen
        textVC.isNewTextView = false
        textVC.presentText = self.currentTextView.text
        textVC.presentFont = UIFont(name: self.currentTextView.font!.fontName, size: self.currentFontSize)
        print("Edit Start  ", self.currentTextView.fontSize)
        textVC.delegate = self
        self.navigationController?.present(textVC, animated: true, completion: nil)
    }
    
    @objc func deleteTextView(){
        self.currentTextView.removeFromSuperview()
        self.currentContainerView.removeFromSuperview()
        self.currentContainerView = nil
        self.currentTextView = nil
    }
    
    func updateFontSize(size: CGFloat) {
        self.currentFontSize = size
    }
    
    
}


extension MainVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(
      _ gestureRecognizer: UIGestureRecognizer,
      shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
      return true
    }

}


