//
//  HeightAndWidthSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 8/28/17.
//
//

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
