//
//  SNCollectionViewCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

class SNCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = SNCollectionViewCell.classFullName
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    var contentItem: CollectionItemCell? {
        willSet {
            newValue?.getSNCell()?.contentItem = nil
        }
        didSet {
            oldValue?.removeFromSuperview()
            if let contentItem = self.contentItem {
                self.contentView.addSubview(contentItem)
                self.setNeedsUpdateLaytouts()
            }
        }
    }
    func configInit() {

    }
    func setNeedsUpdateLaytouts() {
        updateLayout()
    }
}
extension SNCollectionViewCell {
    private func updateLayout() {
        guard let contentItem = self.contentItem else {
            return
        }
        contentItem.updateLayoutsMaker { (maker) in
            maker.edges.equalToSuperview().inset(contentItem.insets)
        }
    }
}
