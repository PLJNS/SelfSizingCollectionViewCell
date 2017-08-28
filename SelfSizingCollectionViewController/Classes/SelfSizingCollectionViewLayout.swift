//
//  SelfSizingCollectionViewLayout.swift
//  Pods
//
//  Created by Paul Jones on 8/28/17.
//
//

open class SelfSizingCollectionViewLayout : UICollectionViewFlowLayout {
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
