//
//  TableItemCell+Height.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

extension TableItemCell {
    func updateHeight<Item: TableCellHeightProtocol>(_ item: Item, _ updates: (() -> Void)?) {
        guard let updater = self.getTableView()?.updater else {
            logError("\(self)->tableView找不到")
            return
        }
        guard updater.isUpdating == false else { return }
        guard CATransform3DIsIdentity(self.layer.transform) else { return }
        guard (try? self.cellState.value()) == .didAppear else { return }
        if item.cellHeightLayoutType == .hasLayout {
            let oldHeight = item.tempCellHeight - self.insetVerticalSpace()
            let height: CGFloat = self.height
            if abs(height - oldHeight) > 2 && height > 0 {
                logDebug("updateHeight -> \(oldHeight) to \(height)")
                item._setNeedResetCellHeight()
            }
        }
        guard item.cellHeightLayoutType == .resetLayout else { return }
        self.setNeedUpdate()
        updater.performBatch(animated: true, updates: updates, completion: { _ in })
    }
}
extension TableItemCell {
    func getItemCellWidth(_ tableView: UITableView) -> CGFloat {
        return tableView.getItemCellWidth(accessoryView, accessoryType) - self.insets.left - self.insets.right
    }
    /*************** 计算TableViewCell高度 ***************/
    func layoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let result: CGFloat
        if let height = self.frameLayoutHeight(contentWidth) {
            result = height
        } else {
            result = self.autoLayoutHeight(contentWidth)
        }
        return result.ceilToNearest(increment: 1)
    }
    /*************** 计算TableViewCell高度 ***************/
    private func frameLayoutHeight(_ contentWidth: CGFloat) -> CGFloat? {
        let viewWidth = contentWidth - insets.left - insets.right
        let viewHeight = self.calculateFrameHeight(viewWidth)
        return viewHeight > 0 ? viewHeight : nil
    }
    private func autoLayoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        return self.calculateAutoLayoutHeight(contentWidth)
    }
}
