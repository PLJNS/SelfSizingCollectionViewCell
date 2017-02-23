//
//  HeightAndWidthSizingCollectionViewCell.swift
//  Pods
//
//  Created by Paul Jones on 2/19/17.
//
//

open class SelfSizingCollectionViewController : UIViewController {
    public var landscapeSectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 120, bottom: 20, right: 120)
    public var portraitSectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    public var smallestPossibleCellSize: CGSize = CGSize(width: 26, height: 26)

    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout.estimatedItemSize = smallestPossibleCellSize // Enables self-sizing, iOS 9 requires this to be the smallest legal value for any of your cells.
        configure(forTraitCollection: traitCollection)
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        for cell in collectionView.visibleCells {
            if let configurableCell = cell as? SelfSizingCollectionViewCell {
                configurableCell.collectionViewWillTransition(toSize: size, withLayout: collectionViewLayout)
            }
        }
        
        collectionView.alpha = 0
        
        coordinator.animate(alongsideTransition: nil, completion: { (context:UIViewControllerTransitionCoordinatorContext) in
            UIView.setAnimationsEnabled(false)
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -self.collectionViewLayout.sectionInset.top), animated: false)
            self.collectionView.reloadData()
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            UIView.setAnimationsEnabled(true)
            UIView.animate(withDuration: 0.25, animations: { 
                self.collectionView.alpha = 1
            })
        })
    }
    
    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        configure(forTraitCollection: newCollection)
    }
    
    func configure(forTraitCollection: UITraitCollection) {
        if forTraitCollection.verticalSizeClass == .regular {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 120, bottom: 20, right: 120)
        }
    }
}

open class SelfSizingCollectionViewCell : UICollectionViewCell {
    public var numberOfCellsPerLine : Int = 1
    internal var collectionViewWidthWithoutInsets : CGFloat = 0
    internal var minimumInteritemSpacing : CGFloat = 0
    
    open func invalidateCache() { assert(false, "must be implemented by subclass") }
    open func configure(forLayout: UICollectionViewFlowLayout) { assert(false, "must be implemented by subclass") }
    open func collectionViewWillTransition(toSize size : CGSize, withLayout : UICollectionViewFlowLayout) { assert(false, "must be implemented by subclass") }
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
