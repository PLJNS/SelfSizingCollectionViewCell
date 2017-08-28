//
//  SelfSizingCollectionViewController.swift
//  Pods
//
//  Created by Paul Jones on 2/19/17.
//
//

/// This class can be subclassed or used as a reference usage of the self-sizing system.
open class SelfSizingCollectionViewController : UIViewController {
    public var landscapeSectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 120, bottom: 20, right: 120)
    public var portraitSectionInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    public var smallestPossibleCellSize: CGSize = CGSize(width: 26, height: 26)
    
    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var collectionViewLayout: SelfSizingCollectionViewLayout!
    
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
        
        collectionViewLayout.invalidateLayout()
        collectionView.alpha = 0
        
        coordinator.animate(alongsideTransition: nil, completion: { (context:UIViewControllerTransitionCoordinatorContext) in
            UIView.setAnimationsEnabled(false)
            self.collectionView.reloadData()
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -self.collectionViewLayout.sectionInset.top), animated: false)  // Scrolling up after a rotate is jumpy because the layout doesn't calculate the full height of what's above it
            self.collectionViewLayout.invalidateLayout()
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
