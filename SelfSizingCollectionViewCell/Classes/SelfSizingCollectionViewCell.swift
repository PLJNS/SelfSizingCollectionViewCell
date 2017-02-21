//
//  SelfSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 2/21/17.
//
//

import Foundation

open class SelfSizingCollectionViewCell : UICollectionViewCell {
    public var numberOfCellsPerLine : Int = 1
    internal var collectionViewWidthWithoutInsets : CGFloat = 0
    internal var minimumInteritemSpacing : CGFloat = 0
    
    open func invalidateCache() {
        assert(false, "must be implemented by subclass")
    }
    
    open func configure(forLayout: UICollectionViewFlowLayout) {
        assert(false, "must be implemented by subclass")
    }
}
