//
//  TextViewVC.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/23/20.
//

import UIKit

protocol TextViewVCDelegate: NSObject {
    func addNewTextSticker(textView: TextView, isNewTextView: Bool)
    func updateFontSize(size: CGFloat)
}

class TextViewVC: UIViewController {
    
    @IBOutlet weak var bottomView: TextBottomView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    fileprivate var keyBoardHeight: CGFloat!
    weak var delegate: TextViewVCDelegate?
    public var isNewTextView = true
    public var presentText: String!
    public var presentFont: UIFont!
    fileprivate var textViewMaxHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.bottomView.delegate = self
        if UIDevice.current.userInterfaceIdiom == .phone {
            textViewMaxHeight = 200.0
        }else{
            textViewMaxHeight = 600.0
        }
    }
    @IBAction func tappedOnStartWritingButton(_ sender: UIButton) {
        self.bottomView.textView.isHidden = false
        self.bottomView.textView.becomeFirstResponder()
       // print("MSMSMSMSMS")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        self.bottomView.hideBarView.layer.cornerRadius = self.bottomView.hideBarView.bounds.height * 0.5
        self.bottomView.collectionViewContainer.layer.cornerRadius = 10
        self.bottomView.collectionViewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.bottomView.alignmentCollectionViewWidthConstraint.constant = (self.bottomView.alignmentCollectionView.bounds.height * 3.0) + 48
        self.bottomView.backgroundCollectionViewWidthConstraint.constant = (self.bottomView.backgroundCollectionView.bounds.height * 3.0) + 48
        self.bottomView.menuContainerWidthConstraint.constant = self.getMenuWidth()
        self.bottomView.textViewWidthConstraint.constant = UIScreen.main.bounds.width
        self.bottomView.textViewHeightConstraint.constant = self.bottomView.textViewContainerView.bounds.height - 20
        self.view.layoutIfNeeded()
        
        if self.presentText != nil {
            self.bottomView.textView.text = self.presentText
        }
        
        if self.presentFont != nil {
            print("viewDidAppear", self.presentFont.pointSize)
            self.bottomView.textView.font = self.presentFont
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = keyboardRectangle.height
            self.bottomViewBottomConstraint.constant = keyBoardHeight
            self.bottomView.panGesture.isEnabled = true
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
       // print("KeyBoard Hide ", self.bottomView.textView.text)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = keyboardRectangle.height
            self.bottomView.panGesture.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

//MARK: TextBottomView Delegate
extension TextViewVC: TextBottomViewDelegate {
    func updateFontSize(size: CGFloat) {
        self.delegate?.updateFontSize(size: size)
    }
    
    
    func goToColorPicker() {
        print("Color Picker")
        let tempTextView = UITextView(frame: self.bottomView.textView.frame)
        tempTextView.font = self.bottomView.textView.font
        tempTextView.text = self.bottomView.textView.text
        tempTextView.textColor = self.bottomView.textView.textColor
    }
    
    func tappedOnHideView() {
        delegate?.addNewTextSticker(textView: self.bottomView.textView, isNewTextView: self.isNewTextView)
        self.bottomView.textView.resignFirstResponder()
        self.bottomView.textView.isHidden = true
        //  print("Line  ", self.bottomView.textView.numberOfLine())
        self.dismiss(animated: true, completion: nil)
    }
    
    func panChangesOnHideView(changes: CGFloat) {
        //  print("Changes ", changes,"  ", self.bottomView.bounds.height * 0.2)
        self.bottomViewBottomConstraint.constant = keyBoardHeight - changes
        if changes >= self.bottomView.bounds.height * 0.2 {
            delegate?.addNewTextSticker(textView: self.bottomView.textView, isNewTextView: self.isNewTextView)
            self.bottomView.textView.resignFirstResponder()
            self.bottomView.textView.isHidden = true
            //   print("Line22  ", self.bottomView.textView.numberOfLine())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func panEndOnHideView(changes: CGFloat) {
        
        if changes >= self.bottomView.bounds.height * 0.2 {
            self.bottomView.textView.resignFirstResponder()
            self.bottomViewBottomConstraint.constant =   -(self.bottomView.bounds.height + keyBoardHeight)
        }else{
            self.bottomViewBottomConstraint.constant = keyBoardHeight
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: Get Menu Width
    fileprivate func getMenuWidth() -> CGFloat {
        var temp: CGFloat = 0.0
        // print("UUUUUU   -----> ", self.bottomView.constant)
        for i in self.bottomView.menuArray {
            temp += (i.widthOfString(usingFont: UIFont.systemFont(ofSize: self.bottomView.fontSize)) + self.bottomView.constant + 16)
        }
        temp += 32
        return min(temp, UIScreen.main.bounds.width)
    }
}
