//
//  InitProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol InitProtocol {
    init()
    static func create() -> Self
}
extension InitProtocol {
    public static func create() -> Self {
        .init()
    }
}
extension String: InitProtocol {}
