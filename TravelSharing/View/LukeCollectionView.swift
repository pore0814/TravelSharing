//
//  LukeCollectionView.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/22.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class LukeCollectionView: UICollectionView {

    override var delegate: UICollectionViewDelegate? {
        didSet {
            print("Did set delegate in collection view.")
        }
    }

    override var contentOffset: CGPoint {
        didSet {
            print("Yoyoyo")
        }
    }

}
