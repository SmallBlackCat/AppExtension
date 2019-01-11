//
//  ItemCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift

public enum CellState {
    case prepare
    case willAppear
    case didAppear
    case didDisappear
    var isAppear: Bool {
        switch self {
        case .willAppear, .didAppear:
            return true
        case .prepare, .didDisappear:
            return false
        }
    }
}
public enum CellAppearAnimationType {
    case none
    case zoomZ
    case slideLeft
}
public enum CellHighlightedAnimationType {
    case none
    case zoom
}
extension ItemCell {
    public static var accessoryTypeSelectedImage: UIImage = UIImage(named: "ic_accessoryType_selected")!
    public static var accessoryTypeUnSelectedImage: UIImage = UIImage(named: "ic_accessoryType_unselected")!
}
open class ItemCell: CustomView, DataSourceItemtype & SelectedStateDesignable & HiddenStateDesignable & EnabledStateDesignable, HighlightedStateDesignable, NeedUpdateProtocol, BufferPoolItemProtocol {

    public static func == (lhs: ItemCell, rhs: ItemCell) -> Bool {
        return lhs.isEqual(rhs)
    }
    // MARK: NeedUpdateProtocol
    private var needUpdateSentinel: Sentinel = Sentinel()
    open func setNeedUpdate() {
        self.needUpdateSentinel.increase()
    }
    // MARK: Differentiable
    open func isContentEqual(to source: ItemCell) -> Bool {
        return self.identity == source.identity
    }
    private var identity: String {
        return "\(self.hashValue)\(self.needUpdateSentinel.value)"
    }
    // MARK: selectedAccessoryType
    public lazy var selectedAccessoryTypeImageView: ImageView = ImageView(image: ItemCell.accessoryTypeSelectedImage)
    public lazy var unselectedAccessoryTypeImageView: ImageView = ImageView(image: ItemCell.accessoryTypeUnSelectedImage)
    // MARK: selectedBackgroundView
    let selectedBackgroundView: ItemCellSelectedBackgroundView = ItemCellSelectedBackgroundView()
    // MARK: - StateProtocol
    /// ZJaDe: isSelected 这个属性由model层的isSelected控制, model层的isSelected可由adapter代理方法控制
    open var isSelected: Bool = false {
        didSet {
            self.isSelectedSubject.onNext(isSelected)
        }
    }
    /// ZJaDe: 当isSelected状态更改时会适时调用该方法，在此作出处理, 子类需要调用super
    open func updateSelectedState(_ isSelected: Bool) {

    }
    private let isSelectedSubject: ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)
    /// ZJaDe: 选中状态更改时发送信号
    open func observerSelectedStateChanged(_ isSelected: Observable<Bool>) -> Observable<Bool> {
        return isSelected
            .throttle(0.1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    /// ZJaDe: 高亮动画
    open var highlightedAnimation: CellHighlightedAnimationType = .none
    /// ZJaDe: 如果canHighlighted值为false将不会出发点击cell的事件 如果仅仅是想不高亮 改变cell的selectionStyle属性
    open var canHighlighted: Bool = true
    /// ZJaDe: isHighlighted 用户手动点击可触发高亮状态 cell层有这个属性
    open var isHighlighted: Bool = false {
        didSet {
            self.isHighlightedSubject.onNext(isHighlighted)
        }
    }
    /// ZJaDe: 当isSelected状态更改时会适时调用该方法，在此作出处理, 子类需要调用super
    open func updateHighlightedState(_ isHighlighted: Bool) {

    }
    private let isHighlightedSubject: ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)
    /// ZJaDe: 高亮状态更改时发送信号
    open func observerHighlightedStateChanged(_ isHighlighted: Observable<Bool>) -> Observable<Bool> {
        return isHighlighted
            .throttle(0.1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    // MARK: - EnabledStateProtocol
    /// ZJaDe: isEnabled 由model层的isEnabled控制，也可由adapter的isEnabled控制
    open var isEnabled: Bool? {
        didSet {
            if let isEnabled = self.isEnabled, isEnabled != oldValue {
                refreshEnabledState(isEnabled)
            }
        }
    }
    /// ZJaDe: 当isEnabled状态更改时会适时调用该方法，在此作出处理
    open func updateEnabledState(_ isEnabled: Bool) {

    }
    /// ZJaDe: 检查是否可以高亮 列表代理方法会调用
    func checkShouldHighlight() -> Bool {
        guard canHighlighted else {
            return false
        }
        if let isEnabled = self.isEnabled {
            return isEnabled
        }
        return isEnabled ?? true
    }
    // MARK: - viewDidLoad
    open override func viewDidLoad() {
        super.viewDidLoad()
        observerSelectedStateChanged(self.isSelectedSubject).subscribeOnNext {[weak self] (isSelected) in
            self?.updateSelectedState(isSelected)
        }.disposed(by: disposeBag)
        observerHighlightedStateChanged(self.isHighlightedSubject).subscribeOnNext {[weak self] (isHighlighted) in
            guard let `self` = self else { return }
            self.updateHighlightedState(isHighlighted)
            self.configHighlightedAnimate(isHighlighted)
        } .disposed(by: disposeBag)
    }
    // MARK: disappear
    open var appearAnimation: CellAppearAnimationType = .zoomZ
    public let cellState: BehaviorSubject<CellState> = BehaviorSubject(value: .prepare)
    public var appearDisposeBag: DisposeBag {
        return self.disposeBagWithTag("appear")
    }
    /// ZJaDe: 一些准备工作
    open func prepareForReuse() {
        self.cellState.onNext(.prepare)
    }
    /// ZJaDe: 负责一些逻辑处理，但是不负责界面布局
    open func willAppear() {
        self.cellState.onNext(.willAppear)
        self.isSelectedSubject.onNext(isSelected)
        self.isHighlightedSubject.onNext(isHighlighted)
        configAppearAnimate()
        if (try? self.cellState.value()) == .willAppear {
            self.cellState.onNext(.didAppear)
        }
    }
    /// ZJaDe: 负责一些逻辑处理，但是不负责界面布局
    open func didDisappear() {
        self.resetDisposeBagWithTag("appear")
        self.cellState.onNext(.didDisappear)
    }

    // MARK: - animate
    open func configAppearAnimate() {
        switch self.appearAnimation {
        case .none:
            break
        case .zoomZ:
            self.alpha = 0.95
            self.layer.transform = CATransform3DMakeScale(0.98, 0.98, 0)
            Animater().duration(0.5).animations {
                self.layer.transform = CATransform3DIdentity
                self.alpha = 1
                }.animate()
        case .slideLeft:
            self.alpha = 0.95
            self.layer.transform = CATransform3DMakeTranslation(-self.width, 0, 0)
            Animater().animations {
                self.alpha = 1
                self.layer.transform = CATransform3DIdentity
                }.animate()
        }
    }
    open func configHighlightedAnimate(_ isHighlighted: Bool) {
        switch self.highlightedAnimation {
        case .none:
            break
        case .zoom:
            Animater().animations {
                if isHighlighted {
                    self.layer.transform = CATransform3DMakeScale(0.95, 0.95, 0.95)
                } else {
                    self.layer.transform = CATransform3DIdentity
                }
            }.animate()
        }
    }
    // MARK: - CellSelectProtocol
    public var didSelectItemClosure: CallBackNoParams?
    public let didSelectItemPubject: PublishSubject<Void> = PublishSubject()
    open func didSelectItem() {
        self.didSelectItemClosure?()
        self.didSelectItemPubject.onNext(())
    }

    // MARK: didLayoutSubviewsClosure
    var didLayoutSubviewsClosure: ((ItemCell) -> Void)?
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.didLayoutSubviewsClosure?(self)
    }
}
