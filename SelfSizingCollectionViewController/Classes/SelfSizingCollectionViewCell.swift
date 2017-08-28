//
//  SelfSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 8/28/17.
//
//

open class SelfSizingCollectionViewCell : UICollectionViewCell {
    public var numberOfCellsPerLine : Int = 1
    internal var collectionViewWidthWithoutInsets : CGFloat = 0
    internal var minimumInteritemSpacing : CGFloat = 0

    open func invalidateCache() { assert(false, "must be implemented by subclass") }
    open func configure(forLayout: UICollectionViewFlowLayout) { assert(false, "must be implemented by subclass") }
    open func collectionViewWillTransition(toSize size : CGSize, withLayout : UICollectionViewFlowLayout) { assert(false, "must be implemented by subclass") }
}
