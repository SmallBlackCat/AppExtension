//
//  CustomCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

public class CustomTableItemCell<ViewType: UIView>: StaticTableItemCell {

    public override func configInit() {
        super.configInit()
        self.canHighlighted = false
        self.cellBackgroundColor = Color.clear
        self.highlightedAnimation = .none
        self.appearAnimation = .none
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.insets = UIEdgeInsets.zero
        self.separatorLineHeight = 0
        self.separatorLineInsets = (0, 0)
    }
    public var customView: ViewType? {
        didSet {
            oldValue?.removeFromSuperview()
            if let customView = self.customView {
                self.addSubview(customView)
                customView.snp.makeConstraints { (maker) in
                    maker.edges.equalToSuperview()
                }
            }
        }
    }
}
