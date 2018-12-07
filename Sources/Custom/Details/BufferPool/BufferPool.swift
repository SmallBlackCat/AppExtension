//
//  BufferPool.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
public protocol BufferPoolItemProtocol {

}

public class BufferPool {
    public init() {}
    private let lock = NSLock()
    private var dataArray: [String: Set<NSObject>] = [:]

    public func push<T: NSObject&BufferPoolItemProtocol>(_ obj: T, key: String?) {
        lock.lock(); defer {lock.unlock()}
        let key = key ?? obj.classFullName
        var set: Set<NSObject> = getSet(key)
        set.insert(obj)
//        logDebug("\(obj)->: \(key) 加入缓存池")
        dataArray[key] = set
    }
    public func pop<T: NSObject&BufferPoolItemProtocol>(_ key: String) -> T? {
        lock.lock(); defer {lock.unlock()}
        let result: T?
        var set: Set<NSObject> = getSet(key)
        if let item = set.first(where: {$0 is T}) {
            result = item as? T
            set.remove(item)
//            logDebug("\(item)->: \(key) 取出缓存池")
        } else {
            result = nil
        }
        dataArray[key] = set
        return result
    }

    public func push<T: NSObject&BufferPoolItemProtocol>(_ obj: T) {
        push(obj, key: obj.classFullName)
    }
    public func pop<T: NSObject&BufferPoolItemProtocol>(_ type: T) -> T? {
        return pop(T.classFullName)
    }

    private func getSet(_ key: String) -> Set<NSObject> {
        return dataArray[key] ?? Set()
    }
}
