//
//  InteractionTransition.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

public enum InteractionOperation {
    case Pop
    case Dismiss
    case Tab
}
private var gestureKey: UInt8 = 0
open class InteractionTransition: UIPercentDrivenInteractiveTransition {
    public var interactiveTransitioning: UIViewControllerInteractiveTransitioning? {
        self.cancel()
        return self.interactionInProgress ? self : nil
    }

    var shouldCompleteTransition: Bool = false
    public fileprivate(set) var interactionInProgress: Bool = false

    public var sensitivityValue: CGFloat = 1.35
    public var interactiveUpdate: ((CGFloat) -> Void)?
    public var interactiveComplete: ((Bool) -> Void)?

    public weak var fromVC: UIViewController?
    public weak var toVC: UIViewController?

    open func wire(to viewCon: UIViewController) {
        prepareGestureRecognizer(in: viewCon)
    }
    func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
    }
    func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) -> CGFloat {
        fatalError()
    }
    // MARK: -
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        fromVC = transitionContext.viewController(forKey: .from)!
        toVC = transitionContext.viewController(forKey: .to)!
        super.startInteractiveTransition(transitionContext)
    }
    open override func update(_ percentComplete: CGFloat) {
        super.update(percentComplete)
        self.interactiveUpdate?(percentComplete)
    }
    open override func cancel() {
        super.cancel()
        self.interactiveComplete?(true)
    }
    open override func finish() {
        super.finish()
        self.interactiveComplete?(false)
    }
}
extension InteractionTransition {
    fileprivate func prepareGestureRecognizer(in viewCon: UIViewController) {
        let panGesture = viewCon.view._panGesture
        panGesture.removeTarget(self, action: #selector(handleGesture(_: )))
        panGesture.addTarget(self, action: #selector(handleGesture(_: )))
    }

    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let view: UIView = gesture.view!.superview!
        switch gesture.state {
        case .began:
            self.interactionInProgress = true
            handleGestureBegin(gesture, view)
        case .changed:
            guard self.interactionInProgress else { return }
            let percentValue = formatPercent(updatePercent(gesture, view))
            self.update(percentValue)
        case .ended, .cancelled:
            guard self.interactionInProgress else { return }
            self.interactionInProgress = false
            if !self.shouldCompleteTransition || gesture.state == .cancelled {
                self.cancel()
            } else {
                self.finish()
            }
        default:
            break
        }
    }
    func formatPercent(_ value: CGFloat) -> CGFloat {
        var value = value
        value *= sensitivityValue
        value = min(value, 0.99)
        value = max(value, 0.01)
        return value
    }
}

private var jd_panKey: UInt8 = 0
extension UIView {
    fileprivate var _panGesture: UIPanGestureRecognizer {
        if let pan = objc_getAssociatedObject(self, &jd_panKey) as? UIPanGestureRecognizer {
            return pan
        } else {
            let pan = UIPanGestureRecognizer()
            self.addGestureRecognizer(pan)
            objc_setAssociatedObject(self, &jd_panKey, pan, .OBJC_ASSOCIATION_RETAIN)
            return pan
        }
    }
}
