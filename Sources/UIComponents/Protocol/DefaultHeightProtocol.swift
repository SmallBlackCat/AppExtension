//
//  DefaultHeightProtocol.swift
//  Core
//
//  Created by 郑军铎 on 2018/6/14.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public protocol DefaultHeightProtocol: class {
    var defaultHeight: CGFloat {get}
}
public protocol WritableDefaultHeightProtocol: class {
    var defaultHeight: CGFloat {get set}
}