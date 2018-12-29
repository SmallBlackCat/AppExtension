//
//  Model.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

open class Model: Hashable, InitProtocol, ClassNameDesignable {

    public required init() {

    }
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    public static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

//    deinit {
//        logDebug("\(type(of: self))->\(self)注销")
//    }
}
