//
//  DynamicCollectionItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class DynamicCollectionItemCell: CollectionItemCell {

    var _model: CollectionItemModel? {
        didSet {
            if let model = self._model {
                didChangedModel(model)
            }
        }
    }
    func didChangedModel(_ model: CollectionItemModel) {}

    open override func didDisappear() {
        super.didDisappear()
        _model?.recycleCell(self)
    }
}
