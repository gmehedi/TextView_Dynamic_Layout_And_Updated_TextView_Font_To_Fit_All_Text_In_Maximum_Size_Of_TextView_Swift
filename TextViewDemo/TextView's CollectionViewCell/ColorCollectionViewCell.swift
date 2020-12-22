//
//  RightCollectionViewCell.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/26/20.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
