//
//  MYHeightSizingCollectionViewCell.swift
//  SizingCollectionView
//
//  Created by Paul Jones on 2/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SelfSizingCollectionViewCell

class ImageCollectionViewCell : HeightSizingCollectionViewCell {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    var image : UIImage? {
        didSet {
            imageView.image = image
        }
    }
}

class SwitchCollectionViewCell : HeightSizingCollectionViewCell { }

class ButtonCollectionViewCell : HeightSizingCollectionViewCell { }
