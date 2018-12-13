//
//  Updater.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import DifferenceKit

public enum ListUpdateMode {
    case everything
    case partial(animated: Bool)
}
public final class Updater<A: Updating> {
    enum State {
        case idle
        case updating
    }
    private var state: State = .idle {
        willSet { assertMainThread() }
    }

    let updating: A
    init(_ updating: A) {
        self.updating = updating
    }
    /// ZJaDe: 刷新或者更新列表, 根据updateMode判断
    func update<C>(
        using stagedChangeset: StagedChangeset<C>,
        updateMode: ListUpdateMode,
        interrupt: ((Changeset<C>) -> Bool)?,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        var updateMode = updateMode
        if updating.isInHierarchy == false {
            updateMode = .everything
        }
        switch updateMode {
        case .everything:
            if let data = stagedChangeset.last?.data {
                reload(
                    data: data,
                    setData: setData,
                    completion: completion
                )
            } else {
                completion(true)
            }
        case .partial(animated: let animated):
            update(
                using: stagedChangeset,
                interrupt: interrupt,
                animated: animated,
                setData: setData,
                completion: completion
            )
        }
    }

    /// ZJaDe: 更新列表
    func update<C>(
        using stagedChangeset: StagedChangeset<C>,
        interrupt: ((Changeset<C>) -> Bool)?,
        animated: Bool,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        self.state = .updating
        self.updating.performBatch(animated: animated, updates: {
            for changeset in stagedChangeset {
                if let interrupt = interrupt, interrupt(changeset), let data = stagedChangeset.last?.data {
                    self.reload(data: data, setData: setData, completion: completion)
                    return
                }
                self.update(changeset: changeset, interrupt: interrupt, setData: setData)
            }
        }, completion: { (result) in
            self.state = .idle
            completion(result)
        })
    }
    /// ZJaDe: 刷新列表
    func reload<C>(
        data: C,
        setData: @escaping (C) -> Void,
        completion: @escaping (Bool) -> Void
        ) {
        self.state = .updating
        setData(data)
        updating.reload {
            self.state = .idle
            completion(true)
        }
    }
}

extension Updater {
    private func update<C>(
        changeset: Changeset<C>,
        interrupt: ((Changeset<C>) -> Bool)?,
        setData: (C) -> Void
        ) {
        setData(changeset.data)
        if !changeset.sectionDeleted.isEmpty {
            updating.deleteSections(IndexSet(changeset.sectionDeleted))
        }
        if !changeset.sectionInserted.isEmpty {
            updating.insertSections(IndexSet(changeset.sectionInserted))
        }
        if !changeset.sectionUpdated.isEmpty {
            updating.reloadSections(IndexSet(changeset.sectionUpdated))
        }
        for (source, target) in changeset.sectionMoved {
            updating.moveSection(source, toSection: target)
        }
        if !changeset.elementDeleted.isEmpty {
            updating.deleteItems(at: changeset.elementDeleted.map(mapIndexPath))
        }
        if !changeset.elementInserted.isEmpty {
            updating.insertItems(at: changeset.elementInserted.map(mapIndexPath))
        }
        if !changeset.elementUpdated.isEmpty {
            updating.reloadItems(at: changeset.elementUpdated.map(mapIndexPath))
        }
        for (source, target) in changeset.elementMoved {
            updating.moveItem(at: mapIndexPath(source), to: mapIndexPath(target))
        }
    }
    private func mapIndexPath(_ indexPath: ElementPath) -> IndexPath {
        return IndexPath(row: indexPath.element, section: indexPath.section)
    }
}