//
//  UICollectionViewFlowLayout.swift
//  Pods
//
//  Created by Paul Jones on 2/21/17.
//
//

import Foundation

extension UICollectionViewFlowLayout {
    var collectionViewWidthWithoutInsets : CGFloat {
        let collectionViewWidth = collectionView?.bounds.size.width ?? 0
        let collectionViewContentInsetLeft = collectionView?.contentInset.left ?? 0
        let collectionViewContentInsetRight = collectionView?.contentInset.right ?? 0
        return collectionViewWidth - sectionInset.left - sectionInset.right - collectionViewContentInsetLeft - collectionViewContentInsetRight
    }
}
