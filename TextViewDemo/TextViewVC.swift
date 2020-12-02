//
//  TextViewVC.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/23/20.
//

import UIKit

class TextViewVC: UIViewController {

    @IBOutlet weak var bottomView: TextBottomView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    fileprivate var keyBoardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomView.delegate = self
    }
    @IBAction func tappedOnStartWritingButton(_ sender: UIButton) {
        self.bottomView.textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bottomView.leftCollectioViewWidthConstraint.constant = ((self.bottomView.leftCollectionView.bounds.height - 8) * 3) + 64
        self.bottomView.hideBarView.layer.cornerRadius = self.bottomView.hideBarView.bounds.height * 0.5
        self.bottomView.collectionViewContainer.layer.cornerRadius = 10
        self.bottomView.collectionViewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyBoardHeight = keyboardRectangle.height
            self.bottomViewBottomConstraint.constant = keyBoardHeight
            self.bottomView.panGesture.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
       
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {

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

extension TextViewVC: TextBottomViewDelegate {
    
    func tappedOnHideView() {
        self.bottomView.textView.resignFirstResponder()
        self.bottomViewBottomConstraint.constant = -(self.bottomView.bounds.height + keyBoardHeight)
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func panChangesOnHideView(changes: CGFloat) {
        print("Changes")
        if changes >= self.bottomView.bounds.height * 0.2 {
            self.bottomView.textView.resignFirstResponder()
            self.bottomViewBottomConstraint.constant =   -(self.bottomView.bounds.height + keyBoardHeight)
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            if changes > 0 {
                self.bottomViewBottomConstraint.constant =  keyBoardHeight - changes
                UIView.animate(withDuration: 0.1, animations: {
                    self.view.layoutIfNeeded()
                })
            }
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
    
}
