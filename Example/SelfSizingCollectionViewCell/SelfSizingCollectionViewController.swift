//
//  MYHeightSizingCollectionViewController.swift
//  SizingCollectionView
//
//  Created by Paul Jones on 2/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SelfSizingCollectionViewCell

class SelfSizingCollectionViewController : UIViewController, UICollectionViewDataSource {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    fileprivate var configuredVerticalSizeClass : UIUserInterfaceSizeClass? // This is so we do not configure and reload the same change.
    
    fileprivate var images : [UIImage] = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "four"), #imageLiteral(resourceName: "five"), #imageLiteral(resourceName: "six")]
    fileprivate var strings : [String] = []
    fileprivate var fontSizes : [CGFloat] = []
    fileprivate var colors : [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDebugData()
        collectionViewLayout.estimatedItemSize = CGSize(width: 26, height: 26) // Set the estimated item size to the *smallest legal size* of all your cells.
        configure() // Initial configuration
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure() // If the subviews have been layed out, we may need to update.
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        /* We're about to change the cell width, so reset the section insets to guard against UICollectionViewFlowLayoutBreakForInvalidSizes. */
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.alpha = 0 // Hide unsightly transition
        coordinator.animate(alongsideTransition: nil) { (context:UIViewControllerTransitionCoordinatorContext) in
            self.configure() // When we're done transitioning, set the new edge insets.
            self.collectionView.alpha = 1 // Bring back the collection view when it's all updated
        }
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    func configure() {
        if traitCollection.verticalSizeClass != configuredVerticalSizeClass { // To defend against layout loops.
            configuredVerticalSizeClass = traitCollection.verticalSizeClass
            
            if traitCollection.verticalSizeClass == .regular {
                collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // You can change these.
            } else {
                collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 120, bottom: 20, right: 120)
            }
            
            collectionViewLayout.invalidateLayout()
            collectionView.reloadData() // We just updated edge insets, which changes our cell widths in many cases, so reload.
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : SelfSizingCollectionViewCell // Cell is of this type so we can configure without casting.
        
        switch indexPath.section % 2 {
        case 0:
            if indexPath.row == 0 {
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
                aCell.image = images[Int(indexPath.section / 2)]
                cell = aCell
            } else {
                switch indexPath.row % 2 {
                case 0:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwitchCollectionViewCell", for: indexPath) as! SwitchCollectionViewCell
                    cell.backgroundColor = .blue
                    cell.numberOfCellsPerLine = Int(ceil(Double(indexPath.section + 1) / 2)) // This is so it goes from being 1, to 2, to 3, etc, by section.
                case 1:
                    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
                    cell.backgroundColor = .red
                    cell.numberOfCellsPerLine = Int(ceil(Double(indexPath.section + 1) / 2))
                default:
                    assert(false, "shouldn't get here")
                    cell = HeightSizingCollectionViewCell()
                }
            }
        case 1:
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelHeightAndWidthSizingCollectionViewCell", for: indexPath) as! LabelHeightAndWidthSizingCollectionViewCell
            aCell.labelTextAndFont = (strings[indexPath.row], fontSizes[indexPath.row])
            aCell.backgroundColor = colors[indexPath.row]
            cell = aCell
        default:
            assert(false, "shouldn't get here")
            cell = HeightSizingCollectionViewCell()
        }
        
        cell.configure(forLayout: collectionViewLayout) // This is important, see concrete subclasses of SelfSizingCollectionViewCell for details.
        
        return cell
    }
}

extension SelfSizingCollectionViewController {
    func createDebugData() {
        for _ in 0..<12 {
            strings.append(String(randomStringOfLength:Int(randomIntBetween: 12, and: 2)))
            fontSizes.append(CGFloat(integerLiteral: Int(randomIntBetween: 42, and: 12)))
            colors.append(UIColor(randomColor: true))
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return images.count * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section % 2 {
        case 0:
            return 3 + (section * 2)
        case 1:
            return strings.count
        default:
            return 0
        }
    }
}


