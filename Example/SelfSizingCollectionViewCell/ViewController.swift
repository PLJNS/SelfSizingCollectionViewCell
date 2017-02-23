//
//  MYHeightSizingCollectionViewController.swift
//  SizingCollectionView
//
//  Created by Paul Jones on 2/20/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SelfSizingCollectionViewCell

class ViewController : SelfSizingCollectionViewController, UICollectionViewDataSource {
    
    fileprivate var images : [UIImage] = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "four"), #imageLiteral(resourceName: "five"), #imageLiteral(resourceName: "six")]
    fileprivate var strings : [String] = []
    fileprivate var fontSizes : [CGFloat] = []
    fileprivate var colors : [UIColor] = []
    
    override func viewDidLoad() {
        generateDebugData()
        super.viewDidLoad()
    }
    
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
    
    func generateDebugData() {
        for _ in 0..<12 {
            strings.append(String(randomStringOfLength:Int(randomIntBetween: 12, and: 2)))
            fontSizes.append(CGFloat(integerLiteral: Int(randomIntBetween: 42, and: 12)))
            colors.append(UIColor(randomColor: true))
        }
    }
}
