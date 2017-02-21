//
//  HeightSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 2/19/17.
//
//

open class HeightSizingCollectionViewCell: SelfSizingCollectionViewCell {
    private var cachedHeight : CGFloat = -1
    
    override open func invalidateCache() {
        cachedHeight = -1
    }
    
    override open func configure(forLayout: UICollectionViewFlowLayout) {
        collectionViewWidthWithoutInsets = forLayout.collectionViewWidthWithoutInsets
        minimumInteritemSpacing = forLayout.minimumInteritemSpacing
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
