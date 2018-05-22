//
//  LukeScrollView.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/22.
//  Copyright © 2018年 Annie. All rights reserved.
//

import UIKit

class LukeScrollView: UIScrollView {

    override var delegate: UIScrollViewDelegate? {
        didSet {
            print("Did set delegate in scroll view.")
        }
    }

}
