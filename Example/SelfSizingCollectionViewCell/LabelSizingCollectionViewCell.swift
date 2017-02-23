//
//  LabelHeightAndWidthSizingCollectionViewCell.swift
//  SizingCollectionView
//
//  Created by Paul Jones on 2/19/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SelfSizingCollectionViewCell

class LabelHeightAndWidthSizingCollectionViewCell : HeightAndWidthSizingCollectionViewCell {
    @IBOutlet fileprivate weak var label: UILabel!
    
    var labelTextAndFont : (_ : String?, _ : CGFloat?)? {
        didSet(oldValue) {
            label.text = labelTextAndFont?.0
            label.font = UIFont.systemFont(ofSize: labelTextAndFont?.1 ?? 0)
            
            if (oldValue?.0 != labelTextAndFont?.0) || (oldValue?.1 != labelTextAndFont?.1) {
                invalidateCache()
            }
        }
    }
}
