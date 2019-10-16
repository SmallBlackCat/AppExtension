//  ViewController.swift
//  SNKit_TJS
//
//  Created by syk on 2018/5/9.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FunctionalSwift

typealias ViewControllerProtocol = RootViewStateProtocol & NetworkProtocol & UpdateDataProtocol
open class ViewController: UIViewController, ViewControllerProtocol {
    public var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }
    // MARK: - init
    public init() {
        super.init(nibName: nil, bundle: nil)
        configInit()
    }
    /// ZJaDe: 重写这个方法是为了还可以使用xib
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        configInit()
    }
    fileprivate var isCoderLoad: Bool = false
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isCoderLoad = true
        configInit()
    }

    // MARK: - 以下几个方法在不同的时候重写
    open func configInit() {

    }

    open override func loadView() {
        super.loadView()
        if self.isCoderLoad == false, let view = createRootView(self.view.frame) {
            self.view = view
        }
    }
    open func createRootView(_ frame: CGRect) -> UIView? {
        nil
    }

    open func setNeedUpdateData() {
        setNeedUpdateData(self.rx.isAppear)
    }
    open func setNeedRequest() {
        setNeedRequest(self.rx.isDidAppear)
    }
    /// ZJaDe: 不要直接调用该方法，使用setNeedRequest()
    open func request() {
        logError("\(self)没实现request方法，请检查该控制器是否需要刷新或者实现request方法")
        jdAbstractMethod()
    }
    /// ZJaDe: 不要直接调用该方法，使用setNeedUpdateData()
    open func updateData() {
        logError("\(self)没实现updateData方法，请检查该控制器是否需要刷新或者实现updateData方法")
        jdAbstractMethod()
    }
    /// ZJaDe: 不要直接调用该方法，重写添加子view
    open func addChildView() {

    }
    /// ZJaDe: 不要直接调用该方法，重写设置约束
    open func configLayout() {

    }
    // MARK: -
    open override func viewDidLoad() {
        super.viewDidLoad()
        viewState.onNext(.viewDidLoad)
        addChildView()
        configLayout()
        view.setNeedsLayout()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewState.onNext(.viewWillAppear)
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewState.onNext(.viewDidAppear)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        viewState.onNext(.viewWillDisappear)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewState.onNext(.viewDidDisappear)
    }
}

open class GenericsViewController<ViewType>: ViewController where ViewType: UIView {
    // MARK: - view
    public final override func createRootView(_ frame: CGRect) -> UIView? {
        createView(frame)
    }
    /// ZJaDe: 重写该方法 返回根视图
    open func createView(_ frame: CGRect) -> ViewType {
        ViewType(frame: frame)
    }
    open var rootView: ViewType {
        // swiftlint:disable force_cast
        return self.view as! ViewType
    }
}
