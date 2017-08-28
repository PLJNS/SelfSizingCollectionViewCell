//
//  UICollectionViewFlowLayout+SelfSizingExtensions.swift
//  Pods
//
//  Created by Paul Jones on 8/28/17.
//
//

extension UICollectionViewFlowLayout {
    var collectionViewWidthWithoutInsets : CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - collectionViewInsetLeftAndRightTotal
    }

    var collectionViewInsetLeftAndRightTotal : CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.contentInset.left + collectionView.contentInset.right + sectionInset.left + sectionInset.right
    }
}
