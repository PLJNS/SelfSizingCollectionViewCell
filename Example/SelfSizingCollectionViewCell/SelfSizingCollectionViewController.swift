//
//  MYHeightSizingCollectionViewController.swift
//  SizingCollectionView
//
//  Created by Paul Jones on 2/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SelfSizingCollectionViewCell

class SelfSizingCollectionViewController : UIViewController {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    fileprivate var images : [UIImage] = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "four"), #imageLiteral(resourceName: "five"), #imageLiteral(resourceName: "six")]
    fileprivate var strings : [String] = []
    fileprivate var fontSizes : [CGFloat] = []
    fileprivate var colors : [UIColor] = []
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create debug data
        for _ in 0..<12 {
            strings.append(String(randomStringOfLength:Int(randomIntBetween: 12, and: 2)))
            fontSizes.append(CGFloat(integerLiteral: Int(randomIntBetween: 42, and: 12)))
            colors.append(UIColor(randomColor: true))
        }
        
        collectionViewLayout.estimatedItemSize = CGSize(width: 26, height: 26) // Enables self-sizing, iOS 9 requires this to be the smallest legal value for any of your cells.
        configure(forTraitCollection: traitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        for cell in collectionView.visibleCells {
            if let configurableCell = cell as? SelfSizingCollectionViewCell {
                configurableCell.collectionViewWillTransition(toSize: size, withLayout: collectionViewLayout)
            }
        }
        
        collectionView.setContentOffset(CGPoint(x: 0, y: -collectionView.contentInset.top), animated: false) // Shouldn't be necessary, but the scrolling up is very janky after a rotate, especially on iOS 9
        collectionViewLayout.invalidateLayout()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        configure(forTraitCollection: newCollection)
    }
    
    // MARK: - Custom
    
    func configure(forTraitCollection: UITraitCollection) {
        if forTraitCollection.verticalSizeClass == .regular {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
            collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 120, bottom: 20, right: 120)
        }
    }
}

extension SelfSizingCollectionViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : SelfSizingCollectionViewCell
        
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
                    cell.numberOfCellsPerLine = Int(ceil(Double(indexPath.section + 1) / 2))
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
        
        cell.configure(forLayout: collectionViewLayout)
        
        return cell
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
