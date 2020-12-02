//
//  ViewController.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/23/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textVC = TextViewVC(nibName: "TextViewVC", bundle: nil)
        self.navigationController?.pushViewController(textVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }


}

