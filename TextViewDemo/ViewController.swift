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
        let mainVC = MainVC(nibName: "MainVC", bundle: nil)
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }


}

