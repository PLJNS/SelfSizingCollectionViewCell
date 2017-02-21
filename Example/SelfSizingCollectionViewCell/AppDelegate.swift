//
//  AppDelegate.swift
//  SelfSizingCollectionViewCell
//
//  Created by PLJNS on 02/21/2017.
//  Copyright (c) 2017 PLJNS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension String {
    init(randomStringOfLength length: Int) {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        let len = UInt32(letters.length)
        
        self = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            self += NSString(characters: &nextChar, length: 1) as String
        }
    }
}

extension Int {
    init(randomIntBetween: Int, and : Int) {
        self = Int(arc4random_uniform(UInt32(randomIntBetween))) + and
    }
}

extension UIColor {
    convenience init(randomColor: Bool) {
        if randomColor {
            self.init(red:CGFloat(drand48()), green:CGFloat(drand48()), blue:CGFloat(drand48()), alpha: 1)
        } else {
            self.init()
        }
    }
}
