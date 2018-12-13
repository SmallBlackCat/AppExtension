//
//  CKPageScrollViewController.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import CollectionKit
/// ZJaDe: 不完善
open class CKPageScrollViewController: CKCollectionViewController {
    public typealias CellType = UIView
    public var viewConArr: [UIViewController] = [] {
        didSet {
            guard oldValue != self.viewConArr else {
                return
            }
            updateProvider()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.isPagingEnabled = true
    }

    func updateProvider() {
        let dataSource = ArrayDataSource(data: self.viewConArr)

        let viewGenerator: (UIViewController, Int) -> UIView = { (viewCon, _) in return viewCon.view }
        let viewSource = ClosureViewSource<UIViewController, UIView>(viewGenerator: viewGenerator, viewUpdater: { (view, data, index) in
        })
        self.scrollView.provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            layout: RowLayout()
        )
    }
}
