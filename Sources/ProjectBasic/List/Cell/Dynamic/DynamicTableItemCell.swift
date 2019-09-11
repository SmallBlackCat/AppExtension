//
//  DynamicTableItemCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
open class DynamicTableItemCell: TableItemCell {

    var isTempCell: Bool = false

    weak var _weakModel: TableItemModel? {
        didSet {
            if let model = self._weakModel {
                didChangedModel(model)
            }
        }
    }
    var _model: TableItemModel?
    func didChangedModel(_ model: TableItemModel) {}

    open override func configInit() {
        super.configInit()
    }
    open override func willAppear() {
        super.willAppear()
        self.getModel()?.hasLoad = true
    }
    open override func configAppearAnimate() {
        if getModel()?.hasLoad == true {
            super.configAppearAnimate()
        }
    }
    open func checkCanSelected(_ closure: @escaping (Bool?) -> Void) {
        closure(nil)
    }
}
