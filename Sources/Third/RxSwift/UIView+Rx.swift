//
//  UIView+Rx.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/25.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

extension Reactive where Base: UIView {
    public func whenTouch(_ closure: ((Base) -> Void)?) -> Disposable {
        return self.tapGesture().asDriver().skip(1).driveOnNext({ (tap) in
            // swiftlint:disable force_cast
            closure?(tap.view as! Base)
        })
    }
}
extension Reactive where Base: UIControl {
    @available(*, deprecated, message: "请使用touchUpInside")
    public func whenTouch(_ closure: ((Base) -> Void)?) -> Disposable {
        return self.touchUpInside(closure)

    }
}
