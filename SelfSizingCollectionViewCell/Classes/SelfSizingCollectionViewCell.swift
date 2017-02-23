//
//  HeightAndWidthSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 2/19/17.
//
//

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
    
    open func collectionViewWillTransition(toSize size : CGSize, withLayout : UICollectionViewFlowLayout) {
        assert(false, "must be implemented by subclass")
    }
}

open class HeightAndWidthSizingCollectionViewCell: SelfSizingCollectionViewCell {
    var cachedSize : CGSize = CGSize(width: -1, height: -1)
    
    override open func invalidateCache() {
        cachedSize = CGSize(width: -1, height: -1)
    }
    
    override open func configure(forLayout: UICollectionViewFlowLayout) {
        collectionViewWidthWithoutInsets = forLayout.collectionViewWidthWithoutInsets
    }
    
    override open func collectionViewWillTransition(toSize size: CGSize, withLayout: UICollectionViewFlowLayout) {
        collectionViewWidthWithoutInsets = size.width - withLayout.collectionViewInsetLeftAndRightTotal
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredLayoutAttributesFitting = super.preferredLayoutAttributesFitting(layoutAttributes)
            
        if cachedSize.height == -1 {
            setNeedsLayout()
            layoutIfNeeded()
            
            cachedSize = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        }
        
        if cachedSize.width > collectionViewWidthWithoutInsets {
            cachedSize.width = collectionViewWidthWithoutInsets
        }
        
        preferredLayoutAttributesFitting.frame.size = cachedSize
        
        return preferredLayoutAttributesFitting
    }
}

open class HeightSizingCollectionViewCell: SelfSizingCollectionViewCell {
    private var cachedHeight : CGFloat = -1
    
    override open func invalidateCache() {
        cachedHeight = -1
    }
    
    override open func configure(forLayout: UICollectionViewFlowLayout) {
        collectionViewWidthWithoutInsets = forLayout.collectionViewWidthWithoutInsets
        minimumInteritemSpacing = forLayout.minimumInteritemSpacing
    }
    
    override open func collectionViewWillTransition(toSize size: CGSize, withLayout: UICollectionViewFlowLayout) {
        collectionViewWidthWithoutInsets = size.width - withLayout.collectionViewInsetLeftAndRightTotal
    }
    
    override open func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let preferredLayoutAttributesFitting = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        if cachedHeight == -1 {
            setNeedsLayout()
            layoutIfNeeded()
            cachedHeight = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        }
        
        let numberOfCellsPerLineFloat = CGFloat(numberOfCellsPerLine)
        let itemWidthWithoutConsideringInteritemSpace = collectionViewWidthWithoutInsets / numberOfCellsPerLineFloat
        let numberOfInteritemSpaces = (numberOfCellsPerLineFloat - 1)
        let amountOfInteritemSpacePerCell = (minimumInteritemSpacing / numberOfCellsPerLineFloat)
        let itemWidth = itemWidthWithoutConsideringInteritemSpace - (numberOfInteritemSpaces * amountOfInteritemSpacePerCell)
        
        preferredLayoutAttributesFitting.frame.size.height = cachedHeight
        preferredLayoutAttributesFitting.frame.size.width = floor(itemWidth)
        
        return preferredLayoutAttributesFitting
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        numberOfCellsPerLine = 1
    }
}

public extension UICollectionViewFlowLayout {
    public var collectionViewWidthWithoutInsets : CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - collectionViewInsetLeftAndRightTotal
    }
    
    public var collectionViewInsetLeftAndRightTotal : CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.contentInset.left + collectionView.contentInset.right + sectionInset.left + sectionInset.right
    }
}
