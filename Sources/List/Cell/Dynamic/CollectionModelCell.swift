//
//  CollectionModelCell.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/9/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
open class CollectionModelCell<ModelType: CollectionItemModel>: DynamicCollectionItemCell, CellModelProtocol {
    public lazy var modelUpdateTask: NeedUpdateTask = {
        let task = NeedUpdateTask()
        task.updateClosure = {[weak self] in
            guard let `self` = self else {
                return
            }
            self.configData(with: self.model)
            self.setNeedsLayout()
        }
        task.configLimitObservableArr(self.getModelUpdateLimit())
        return task
    }()
    open func getModelUpdateLimit() -> [Observable<Bool>] {
        return [self.cellState.asObservable().map {$0 == .willAppear}.distinctUntilChanged()]
    }
    // MARK: -
    override var _model: CollectionItemModel? {
        get {return self.model}
        set {self.model = newValue as? ModelType ?? ModelType()}
    }
    public var model: ModelType {
        didSet {
            modelUpdateTask.setNeedUpdate()
        }
    }
    public convenience init() {
        self.init(model: ModelType())
    }
    public required init(model: ModelType) {
        self.model = model
        super.init(frame: CGRect.zero)
        modelUpdateTask.setNeedUpdate()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.model = ModelType()
        super.init(coder: aDecoder)
        modelUpdateTask.setNeedUpdate()
    }

    open func configData(with model: ModelType) {

    }
}
