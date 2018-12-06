//
//  DismissInteractionController.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

public enum DismissDirection {
    case horizontal(leftToRight: Bool)
    case vertical(topToBottom: Bool)
}

open class DismissInteractionController: InteractionController {
    public var dismissDirection: DismissDirection = .vertical(topToBottom: true)

    open override func handleGestureBegin(_ gesture: UIGestureRecognizer, _ view: UIView) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        super.handleGestureBegin(gesture, view)
        viewController?.dismiss(animated: true, completion: nil)
    }
    open override func updatePercent(_ gesture: UIGestureRecognizer, _ view: UIView) {
        guard let gesture = gesture as? UIPanGestureRecognizer else {
            fatalError()
        }
        let translation = gesture.translation(in: view)

        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        switch self.dismissDirection {
        case .horizontal:
            percentValue = translation.x / screenWidth
        case .vertical:
            percentValue = translation.y / screenHeight
        }

        let velocity = gesture.velocity(in: view)
        switch self.dismissDirection {
        case .horizontal(leftToRight: let leftToRight):
            self.shouldCompleteTransition = leftToRight == (velocity.x > 0)
        case .vertical(topToBottom: let topToBottom):
            self.shouldCompleteTransition = topToBottom == (velocity.y > 0)

        }
    }
}
